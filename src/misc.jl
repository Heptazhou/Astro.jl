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

@reexport using AstroLib: AstroLib, AU,
	airtovac, vactoair,
	altaz2hadec,
	co_aberration, co_nutate, co_refract,
	nutate, precess
export LS, LY, PC

const LS = 299_792_458
const LY = 9_460_730_472_580_800
const PC = 648_000AU / π

