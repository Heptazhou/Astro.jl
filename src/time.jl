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

@reexport using AstroLib:
	JULIANCENTURY, JULIANYEAR
@reexport using Dates: Dates, DateTime, Date, Time, UTC, UTD, UTM,
	Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond
@reexport using Dates: now, today, value,
	year, month, week, day, hour, minute, second, millisecond, microsecond, nanosecond
@reexport using Dates: dayofweek, dayofweekofmonth, dayofyear, daysinmonth, isleapyear,
	datetime2julian, julian2datetime,
	datetime2rata, rata2datetime,
	datetime2unix, unix2datetime
export J2000_TO_JULIAN, J2000_TO_MJD, MJD_TO_JULIAN
export j2000, j2000year, julian, mjd, modified_julian,
	datetime2j2000, j20002datetime,
	datetime2mjd, mjd2datetime

const J2000_TO_JULIAN = 2451545.0
const J2000_TO_MJD    = 0051544.5
const MJD_TO_JULIAN   = 2400000.5

const EPOCH_JUL = value(DateTime(-4713, 11, 24, 12))::Int64
const EPOCH_MJD = value(DateTime(+1858, 11, 17, 00))::Int64
const EPOCH_NIX = value(DateTime(+1970, 01, 01, 00))::Int64
const EPOCH_J2K = value(DateTime(+2000, 01, 01, 12))::Int64

for x ∈ (:EPOCH_JUL, :EPOCH_MJD, :EPOCH_NIX, :EPOCH_J2K)
	@eval @doc """	$($(string(x)))::$(typeof($x)) = $(signpad(DateTime(UTM($x)))) = $($x)""" $x
end

const datetime2j2000(dt::DateTime) = (value(dt) - EPOCH_J2K) / 86400_000Float64
const datetime2mjd(dt::DateTime)   = (value(dt) - EPOCH_MJD) / 86400_000Float64
const j20002datetime(x::Real)      = DateTime(UTM(EPOCH_J2K + round(Int64, (86400_000BigInt)x)))
const mjd2datetime(x::Real)        = DateTime(UTM(EPOCH_MJD + round(Int64, (86400_000BigInt)x)))

const j2000(d::Date)       = datetime2j2000(DateTime(d) + 12Hour) |> Int64
const j2000(dt::DateTime)  = datetime2j2000(dt)
const julian(d::Date)      = datetime2julian(DateTime(d))
const julian(dt::DateTime) = datetime2julian(dt)
const mjd(d::Date)         = datetime2mjd(DateTime(d)) |> Int64
const mjd(dt::DateTime)    = datetime2mjd(dt)

const j2000(x::Real)     = j20002datetime(x)
const j2000year(x::Real) = j20002datetime((x - 2000)JULIANYEAR)
const julian(x::Real)    = julian2datetime(x)
const mjd(x::Integer)    = mjd2datetime(x) |> Date
const mjd(x::Real)       = mjd2datetime(x)
const modified_julian(x) = mjd(x)

const j2000year(d::DateType) = 2000 + JULIANYEAR \ j2000(d)
Dates.today(::Type{UTC})     = Date(now(UTC))

