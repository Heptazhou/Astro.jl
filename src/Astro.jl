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

module Astro

import Base.*

using Dates: DateTime, Date
using Reexport: @reexport

const DateType = Union{DateTime, Date}
const VecOrTup = Union{VecOrMat, Tuple}

*(x::Real, ::Type{T}) where T = T(x)
*(x::Real, f::Function)       = f(x)

include("misc.jl")
include("time.jl")
include("unit.jl")

include("coor.jl") # time, unit

end # module Astro

