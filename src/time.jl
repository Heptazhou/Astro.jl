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

@reexport using AstroLib:
	JULIANCENTURY, JULIANYEAR
@reexport using AstroTime: AstroTime,
	AstroDates
@reexport using Dates: Dates, DateTime, Date, Time, UTC, UTD, UTM,
	Year, Month, Week, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond
@reexport using Dates: now, today, value,
	year, month, week, day, hour, minute, second, millisecond, microsecond, nanosecond
@reexport using Dates: dayofweek, dayofweekofmonth, dayofyear, daysinmonth, isleapyear,
	datetime2julian, julian2datetime,
	datetime2rata, rata2datetime,
	datetime2unix, unix2datetime
export j2000, j2000year, julian, mjd,
	datetime2j2000, j20002datetime,
	datetime2mjd, mjd2datetime

const j2000(d::Date)          = AstroTime.j2000(AstroTime.Date(d))
const j2000(dt::DateTime)     = AstroTime.j2000(AstroTime.DateTime(dt - 12Hour))
const j2000year(d::Date)      = 2000 + JULIANYEAR \ j2000(d)
const j2000year(dt::DateTime) = 2000 + JULIANYEAR \ j2000(dt)
Dates.today(::Type{UTC})      = Date(now(UTC))

const EPOCH_JUL = value(DateTime(-4713, 11, 24, 12))
const EPOCH_MJD = value(DateTime(+1858, 11, 17, 00))
const EPOCH_NIX = value(DateTime(+1970, 01, 01, 00))
const EPOCH_J2K = value(DateTime(+2000, 01, 01, 12))

const datetime2j2000(dt::DateTime) = (value(dt) - EPOCH_J2K) / 86400000Float64
const datetime2mjd(dt::DateTime)   = (value(dt) - EPOCH_MJD) / 86400000Float64
const j20002datetime(x::Real)      = DateTime(UTM(EPOCH_J2K + round(Int64, (86400000BigInt)x)))
const mjd2datetime(x::Real)        = DateTime(UTM(EPOCH_MJD + round(Int64, (86400000BigInt)x)))

const julian(d::Date)      = datetime2julian(d |> DateTime)
const julian(dt::DateTime) = datetime2julian(dt)
const mjd(d::Date)         = datetime2mjd(d |> DateTime) |> Int64
const mjd(dt::DateTime)    = datetime2mjd(dt)

const j2000(x::Real)  = x |> j20002datetime
const julian(x::Real) = x |> julian2datetime
const mjd(x::Integer) = x |> mjd2datetime |> Date
const mjd(x::Real)    = x |> mjd2datetime

