# Copyright (C) 2023-2024 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

@reexport using AstroAngles: AstroAngles,
	deg2dms,
	deg2hms,
	ha2dms,
	ha2hms,
	rad2dms,
	rad2ha,
	rad2hms
@reexport using AstroLib: radec,
	rad2sec,
	sec2rad

for f ∈ [
	:deg2ha
	:dms2deg
	:dms2ha
	:dms2hms
	:dms2rad
	:ha2deg
	:ha2rad
	:hms2deg
	:hms2dms
	:hms2ha
	:hms2rad
]
	@eval export $f
	@eval const $f(parts) = $f(parts...)
end

const deg2ha(angle::Real) = 024rem(angle, 360) / 360
const ha2deg(angle::Real) = 360rem(angle, 024) / 024
const ha2rad(angle::Real) = (π)rem(angle, 024) / 012

const dms2deg(d::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(d, m, s))
const dms2ha(d::Real, m::Real = 0, s::Real = 0)  = Float64.(shift_l(d, m, s) |> deg2ha)
const dms2hms(d::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(d, m, s) |> deg2hms)
const dms2rad(d::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(d, m, s) |> deg2rad)
const hms2deg(h::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(h, m, s) |> ha2deg)
const hms2dms(h::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(h, m, s) |> ha2dms)
const hms2ha(h::Real, m::Real = 0, s::Real = 0)  = Float64.(shift_l(h, m, s))
const hms2rad(h::Real, m::Real = 0, s::Real = 0) = Float64.(shift_l(h, m, s) |> ha2rad)

const shift_l(a::Real, b::Real;
	base::Int = 060) = b ≈ 0 ? (a) :
	base^1 \ big((signbit(a) ? (-) : (+))(a * base^1, abs(b)))
const shift_l(a::Real, b::Real, c::Real;
	base::Int = 060) = c ≈ 0 ? shift_l(a, b) :
	base^2 \ big((signbit(a) ? (-) : (+))(a * base^2, abs(b) * base^1 + abs(c)))

