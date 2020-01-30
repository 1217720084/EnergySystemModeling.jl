module EnergySystemModel

using JuMP, JSON, CSV
using JuMP.Containers

export Specs, energy_system_model, load_parameters

"""Load parameters"""
function load_parameters(instance_path)
    # Load indexes and constant parameters
    p = JSON.parsefile(joinpath(instance_path, "parameters.json"))

    # Indices
    indices = p["indices"]
    G = indices["G"]
    G_r = indices["G_r"]
    N = indices["N"]
    L = indices["L"]
    # FIXME: clustering, time steps
    T = 1:indices["T"]
    S = indices["S"]

    # Constant parameters
    constants = p["constants"]
    κ = constants["kappa"]
    C = constants["C"]
    # TODO: clustering, τ

    # Load time clustered parameters
    # We use DenseAxisArray because indices might be non-integers.
    demand = DenseAxisArray(zeros(length(T), length(N)), T, N)
    wind = DenseAxisArray(zeros(length(T), length(N)), T, N)
    solar = DenseAxisArray(zeros(length(T), length(N)), T, N)
    for n in N
        # Load node values from CSV files.
        df = CSV.read(joinpath(instance_path, "nodes", "$n.csv"))
        load_mod = Float64.(df.Load_mod)
        wind_avaiable = Float64.(df.Avail_Win)
        solar_available = Float64.(df.Avail_Sol)
        max_load = Float64.(df.Max_Load[1])
        dem_inc = Float64.(df.Dem_Inc[1])

        # TODO: clustering

        # Compute the demands.
        # demand[:, n] = dem_inc .* nothing .* max_load
        # wind[:, n] = nothing
        # solar[:, n] = nothing
    end

    # Load technology parameters
    technology = CSV.read(joinpath(instance_path, "technology.csv"))
    I_g = technology.I
    M_g = technology.M
    C_g = technology.C
    r⁻ = technology.r_minus
    r⁺ = technology.r_plus

    # Load transmission parameters
    transmission = CSV.read(joinpath(instance_path, "transmission.csv"))
    I_l = transmission.I
    M_l = transmission.M
    C_l = transmission.C
    B_l = transmission.B

    # Load storage parameters
    storage = CSV.read(joinpath(instance_path, "storage.csv"))
    ξ_s = storage.xi
    I_s = storage.I
    C_s = storage.C
    # TODO: initial storage
    # b⁰_sn = ...

    # Return tuple (maybe namedtuple?)
    # TODO: return demand/availability
    return (G, G_r, N, L, T, S, κ, C, I_g, M_g, C_g, r⁻, r⁺, I_l, M_l, C_l,
            B_l, ξ_s, I_s, C_s)
end

"""Specs"""
struct Specs
    # TODO: booleans
end

"""Create energy system model."""
function energy_system_model()::Model
    # Create an instance of JuMP model.
    model = Model()

    # TODO: variables
    # TODO: objective
    # TODO: constraints

    return model
end

end # module
