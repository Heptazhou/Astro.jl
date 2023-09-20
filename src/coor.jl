# Copyright (C) 2023 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

@reexport using SkyCoords: SkyCoords, AbstractSkyCoords
using SkyCoords:
	EclipticCoords,
	FK5Coords,
	GalCoords,
	ICRSCoords
export @J_str, coor2dd, coor2hd, coor2rr,
	CoorEcliptic,
	CoorEquatorial, CoorFK5,
	CoorGalactic,
	CoorICRS

Base.Tuple(coor::AbstractSkyCoords) = (SkyCoords.lon(coor), SkyCoords.lat(coor))
const coor2dd(coor::AbstractSkyCoords) = Tuple(coor) |> t -> (rad2deg(t[1]), rad2deg(t[2]))
const coor2hd(coor::AbstractSkyCoords) = Tuple(coor) |> t -> (rad2hms(t[1]), rad2dms(t[2]))
const coor2rr(coor::AbstractSkyCoords) = Tuple(coor)
const DateType = Union{DateTime, Date}
const VecOrTup = Union{VecOrMat, Tuple}

# https://en.wikipedia.org/wiki/Equatorial_coordinate_system
const CoorEquatorial(xs...)                             = CoorFK5(xs...)
const CoorFK5(α::Any, δ::Any, d::DateType)              = CoorFK5(α, δ, j2000year(d))
const CoorFK5(α::Real, δ::Real, e::Real = 2000)         = FK5Coords{Float64(e)}(deg2rad(α), deg2rad(δ))
const CoorFK5(α::VecOrTup, δ::VecOrTup, e::Real = 2000) = FK5Coords{Float64(e)}(hms2rad(α), dms2rad(δ))
const CoorICRS(α::Real, δ::Real)                        = ICRSCoords(deg2rad(α), deg2rad(δ))
const CoorICRS(α::VecOrTup, δ::VecOrTup)                = ICRSCoords(hms2rad(α), dms2rad(δ))

# https://en.wikipedia.org/wiki/Ecliptic_coordinate_system
const CoorEcliptic(λ::Any, β::Any, d::DateType)              = CoorEcliptic(λ, β, j2000year(d))
const CoorEcliptic(λ::Real, β::Real, e::Real = 2000)         = EclipticCoords{Float64(e)}(deg2rad(λ), deg2rad(β))
const CoorEcliptic(λ::VecOrTup, β::VecOrTup, e::Real = 2000) = EclipticCoords{Float64(e)}(hms2rad(λ), dms2rad(β))

# https://en.wikipedia.org/wiki/Galactic_coordinate_system
const CoorGalactic(l::Real, b::Real)         = GalCoords(deg2rad(l), deg2rad(b))
const CoorGalactic(l::VecOrTup, b::VecOrTup) = GalCoords(hms2rad(l), dms2rad(b))

const CoorEcliptic(d::DateType)                       = CoorEcliptic(j2000year(d))
const CoorEcliptic(e::Real = 2000)                    = x::AbstractSkyCoords -> CoorEcliptic(x, e)
const CoorEcliptic(x::AbstractSkyCoords, d::DateType) = CoorEcliptic(x, j2000year(d))
const CoorFK5(d::DateType)                            = CoorFK5(j2000year(d))
const CoorFK5(e::Real = 2000)                         = x::AbstractSkyCoords -> CoorFK5(x, e)
const CoorFK5(x::AbstractSkyCoords, d::DateType)      = CoorFK5(x, j2000year(d))

const CoorEcliptic(x::AbstractSkyCoords, e::Real = 2000) = EclipticCoords{Float64(e)}(x)
const CoorFK5(x::AbstractSkyCoords, e::Real = 2000)      = FK5Coords{Float64(e)}(x)
const CoorGalactic(x::AbstractSkyCoords)                 = GalCoords(x)
const CoorICRS(x::AbstractSkyCoords)                     = ICRSCoords(x)

const SDSS(α::Integer, δ::Integer) = hms2deg(α ÷ 100, α % 100), dms2deg(δ ÷ 100, δ % 100) |> d -> copysign(d, δ)
const SDSS(α::Float32, δ::Float32) = SDSS(round.(Int16, (α, δ))...)
const SDSS(α::Float64, δ::Float64) = begin
	hms2deg(Int16(α ÷ 10000), Int16(α ÷ 100 % 100), (α % 100)),
	dms2deg(Int16(δ ÷ 10000), Int16(δ ÷ 100 % 100), (δ % 100)) |> d -> copysign(d, δ)
end

macro J_str(string)
	coor = split(string, r"(?=[+-])") |> NTuple{2, String}
	type = contains.(coor, r"^[+-]?\d{5}") |> any ? Float64 : Float32
	SDSS(parse.(type, coor)...)
end

