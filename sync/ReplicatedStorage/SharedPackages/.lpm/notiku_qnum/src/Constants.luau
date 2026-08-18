--!strict

local Constants = {}

-- Base suffixes for the first three magnitudes (10^3, 10^6, 10^9).
-- Larger magnitudes are generated combinatorially from the -illion tables below.
Constants.SETS = { "k", "M", "B" }

-- Ones-place prefixes for the n-th -illion (Un-, Duo-, Tre-, Quattuor-, Quin-, ...).
-- Index 1 is the empty prefix used when the ones digit is zero.
-- Doubles as the standalone suffix for n in 3..9: T, Qd, Qn, Sx, Sp, Oc, No.
Constants.FIRST_ONES = {
	"", "U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No"
}

-- Tens-place suffixes (Decillion, Vigintillion, Trigintillion, ...).
-- Index 1 is the empty suffix used when the tens digit is zero.
Constants.SECOND_ONES = {
	"", "Dc", "Vg", "Tg", "Qag", "Qig", "Sxg", "Spg", "Ocg", "Nog"
}

-- Hundreds-place suffixes (Centillion, Ducentillion, Trecentillion, ...).
-- Index 1 is the empty suffix used when the hundreds digit is zero.
Constants.THIRD_ONES = {
	"", "Ce", "Dn", "Tc", "Qac", "Qic", "Sxc", "Spc", "Occ", "Noc"
}

return Constants
