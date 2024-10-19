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

using Astro, Test
using AstroTime: AstroTime

Base.isapprox(a::Tuple, b::Tuple) = all(a .≈ b)

@testset "Astro.jl" begin
	local t1, t2 = DateTime.([-1, 2000])
	local signpad = Astro.signpad
	@test signpad(t2) == lpad(t2, 20)
	@test signpad(t1) == lpad(t1, 20)
	@test signpad(+1) == " 1"
	@test signpad(+0) == " 0"
	@test signpad(-1) == "-1"
end

@testset "coor.jl" begin
	local SDSS = Astro.SDSS
	# https://classic.sdss.org/dr7/coverage/IAU.html
	@test SDSS(0810, -0006) ≡ (122.5, -00.1)
	@test SDSS(0810, +0006) ≡ (122.5, +00.1)
	#
	@test SDSS(1416, -0010) ≡ J"1416-0010" ≡ J"141600.00-001000.0"
	@test SDSS(1416, +0010) ≡ J"1416+0010" ≡ J"141600.00+001000.0"
	#
	@test SDSS(123456.89, -012345.6) ≡ J"123456.89-012345.6"
	@test SDSS(123456.89, +012345.6) ≡ J"123456.89+012345.6"
	#
	for f ∈ (coor2dd, coor2hd, coor2rr)
		local a, b = (12, 34, 56.89), (-01, 23, 45.6)
		local c, d = SDSS(123456.89, -012345.6)
		local y, z = rand(UInt16), 2100
		@test f(CoorEcliptic(a, b, y)) ≈ f(CoorEcliptic(c, d, Date(y)))
		@test f(CoorFK5(a, b, y)) ≈ f(CoorFK5(c, d, Date(y)))
		@test f(CoorGalactic(a, b)) ≈ f(CoorGalactic(c, d))
		@test f(CoorICRS(a, b)) ≈ f(CoorICRS(c, d))
		for coor ∈ (CoorEcliptic(c, d), CoorFK5(c, d), CoorGalactic(c, d), CoorICRS(c, d))
			@test f(CoorEcliptic(z)(coor)) ≡ f(CoorEcliptic(Date(z))(coor))
			@test f(CoorEquatorial(z)(coor)) ≡ f(CoorEquatorial(Date(z))(coor))
		end
		@test f(CoorEcliptic(c, d)) ≡ f(CoorEcliptic(CoorEcliptic(c, d), Date(2000)))
		@test f(CoorFK5(c, d)) ≡ f(CoorFK5(CoorFK5(c, d), Date(2000)))
		@test f(CoorGalactic(c, d)) ≡ f(CoorGalactic(CoorGalactic(c, d)))
		@test f(CoorICRS(c, d)) ≡ f(CoorICRS(CoorICRS(c, d)))
	end
end

@testset "misc.jl" begin
	@test AU ≡ 0_000_149_597_870_700
	@test LS ≡ 0_000_000_299_792_458
	@test LY ≡ 9_460_730_472_580_800
	@test PC ≡ 0_000_000_000_648_000AU / π
end

@testset "time.jl" begin
	@test 2100.0 ≡ j2000year(Date(2100.0))
	@test J2000_TO_JULIAN ≡ J2000_TO_MJD + MJD_TO_JULIAN
	@test JULIANYEAR ≡ JULIANCENTURY / 100
	for dt ∈ (value(today(UTC)), rand(Int32) + rand(Float64)) .|> mjd2datetime
		@test value(j2000(00)) ≡ Astro.EPOCH_J2K ≡ value(j2000year(2e3))
		@test value(julian(0)) ≡ Astro.EPOCH_JUL ≡ Dates.JULIANEPOCH
		@test value(mjd(0.00)) ≡ Astro.EPOCH_MJD ≡ value(DateTime(0mjd))
		#
		@test 2000 + JULIANYEAR \ j2000(dt) ≈ j2000year(dt)
		@test datetime2j2000(dt) ≡ j2000(dt) ≡ mjd(dt) - J2000_TO_MJD
		@test datetime2julian(dt) - datetime2j2000(dt) ≡ J2000_TO_JULIAN
		@test datetime2julian(dt) - datetime2mjd(dt) ≡ MJD_TO_JULIAN
		@test datetime2mjd(dt) - datetime2j2000(dt) ≡ J2000_TO_MJD
		@test floor(Int, j2000(dt) + 00.5) ≡ j2000(Date(dt))
		@test floor(Int, julian(dt) + 0.5) ≡ julian(Date(dt)) + 0.5 |> Int
		@test floor(Int, mjd(dt) + 0000.0) ≡ modified_julian(Date(dt))
	end
	local Atime = AstroTime
	for dd ∈ 01:04
		@test isa(Dates.Date(1582, 10, dd), Dates.Date)
		@test isa(Atime.Date(1582, 10, dd), Atime.Date)
	end
	for dd ∈ 05:14
		@test isa(Dates.Date(1582, 10, dd), Dates.Date)
		@test_throws ArgumentError("Invalid date.") Atime.Date(1582, 10, dd)
	end
	for dd ∈ 15:31
		@test isa(Dates.Date(1582, 10, dd), Dates.Date)
		@test isa(Atime.Date(1582, 10, dd), Atime.Date)
	end
end

@testset "unit.jl" begin
	for i ∈ 1:2
		local deg = nextfloat(rand(Float64)) * 360(-1)^i
		local dms = deg2dms(deg)
		local hms = deg2hms(deg)
		local rad = deg2rad(deg)
		#
		@test deg |> deg2dms |> dms2deg ≈ deg
		@test deg |> deg2hms |> hms2deg ≈ deg
		#
		@test rad |> rad2dms |> dms2rad ≈ rad
		@test rad |> rad2hms |> hms2rad ≈ rad
		#
		@test dms |> dms2hms |> hms2ha |> ha2dms ≈ dms
		@test hms |> hms2dms |> dms2ha |> ha2hms ≈ hms
		#
		@test radec(abs(deg), (deg / 4)) ≈ (
			deg2hms(abs(deg))..., deg2dms((deg / 4))...)
		@test radec(abs(deg / 15), 00, hours = true) ≈ (
			deg2dms(abs(deg / 15))..., deg2dms((00))...)
	end
end

