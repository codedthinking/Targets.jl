module Targets

using SHA
using MacroTools

export @target, @get, Target, get_value

# this submodule will store all the variables and targets
module Variables
end

mutable struct Target
    value::Any
    recipe::Union{Symbol, Nothing}
    inputs::Vector{Symbol}
    content_hash::String
    is_valid::Bool
    
    Target(value::Any) = new(value, nothing, Symbol[], hash_value(value), true)
    Target(recipe::Symbol, inputs::Vector{Symbol}) = new(nothing, recipe, inputs, "", false)
end

function hash_value(value::Any)
    bytes2hex(sha256(string(value)))
end

function get_function_ast(func_name::Symbol, input_symbols::Vector{Symbol})
    func = getfield(Main, func_name)
    input_types = Tuple(typeof(getfield(Variables, sym).value) for sym in input_symbols)
    method = Base.which(func, input_types)
    
    if method === nothing
        error("No method found for function $func_name with given input types")
    end

    ast = Base.uncompressed_ast(method)
    
    if ast === nothing
        # For built-in or intrinsic functions, fall back to a string representation
        return string(method)
    end
    
    clean_ast = Base.remove_linenums!(ast)
    
    return clean_ast
end

function hash_function(func_name::Symbol, input_symbols::Vector{Symbol})
    ast = get_function_ast(func_name, input_symbols)
    bytes2hex(sha256(string(ast)))
end

function compute_hash(target::Target)
    if isnothing(target.recipe)
        return target.content_hash
    else
        input_hashes = [getfield(Variables, name).content_hash for name in target.inputs]
        recipe_hash = hash_function(target.recipe, target.inputs)
        return bytes2hex(sha256(join([input_hashes..., recipe_hash])))
    end
end

function is_stale(target::Target)
    !target.is_valid || 
    (target.recipe !== nothing && (
        any(name -> is_stale(getfield(Variables, name)), target.inputs) ||
        compute_hash(target) != target.content_hash
    ))
end

function recreate(target::Target)
    if target.recipe !== nothing
        for name in target.inputs
            input_target = getfield(Variables, name)
            is_stale(input_target) && recreate(input_target)
        end
        
        input_values = [getfield(Variables, name).value for name in target.inputs]
        func = getfield(Main, target.recipe)
        target.value = func(input_values...)
        target.content_hash = compute_hash(target)
    end
    target.is_valid = true
    target
end

function ensure_up_to_date(target::Target)
    is_stale(target) && recreate(target)
    target
end

function get_value(target::Target)
    ensure_up_to_date(target)
    target.value
end

macro target(expr)
    @capture(expr, name_ = value_) || error("Invalid syntax for @target macro")
    
    if @capture(value, func_(args__))
        quote
            Core.eval(Variables, :($($(QuoteNode(name))) = $(Target($(QuoteNode(func)), Symbol[$(QuoteNode.(args)...)]))))
        end
    else
        quote
            Core.eval(Variables, :($($(QuoteNode(name))) = $(Target($(esc(value))))))
        end
    end
end

macro get(expr)
    expr isa Symbol || error("Invalid syntax for @get macro")
    
    quote
        $expr = get_value(getfield(Targets.Variables, $(QuoteNode(expr))))
    end |> esc
end

function reset_targets!()
    for name in names(Variables; all=true)
        if isa(getfield(Variables, name), Target)
            Core.eval(Variables, :($name = nothing))
        end
    end
end

end # module