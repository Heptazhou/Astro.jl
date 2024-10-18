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

module Astro

import Base.*

using Dates: DateTime, Date
using Reexport: @reexport

const DateType = Union{DateTime, Date}
const VecOrTup = Union{VecOrMat, Tuple}

*(x::Real, ::Type{T}) where T = T(x)
*(x::Real, f::Function)       = f(x)

signpad(x::Any)::String    = signpad(string(x))
signpad(x::Real)::String   = signbit(x) ? "$x" : " $x"
signpad(x::String)::String = isdigit(x[begin]) ? " $x" : x

include("misc.jl")
include("time.jl")
include("unit.jl")

include("coor.jl") # time, unit

end # module Astro

