extends Node

var GoodNames = [
	"Jessica",
	"James",
	"Derek",
	"Elli",
	"Fletch",
	"Cicely",
	"Geert",
	"Mary Ann",
	"Cissy",
	"Yeppenny",
	"Ri",
	"Soren",
	"Mai",
	"Tonton",
	"Elaine",
	"Esther",
	"Manny",
	"Becca",
	"Julie",
	"Krista",
	"Cami",
	"Sheres",
	"Noir",
	"Jessie",
	"Zevy",
	"Rachel"
]

var BadNamePrefix = [
	"Greg",
	"Honk",
	"Ding",
	"Jung",
	"Jerm",
	"Mr. A",
	"Ms. E",
	"Mx. O"
]

var BadNameInfix = [
	"ler",
	"dle",
	"brow",
	"hart",
	"fin",
	"wawa",
	"bibi",
	"joo",
	"wee"
]

var BadNameSuffix = [
	"",
	"s",
	"y",
	"ly",
	"ski",
	"doo",
	"ee"
]

func generate_good_name():
	return GoodNames[Global.rng.randi() % GoodNames.size()]
	
func generate_bad_name():
	var prefix = BadNamePrefix[Global.rng.randi() % BadNamePrefix.size()]
	var infix = BadNameInfix[Global.rng.randi() % BadNameInfix.size()]
	var suffix = BadNameSuffix[Global.rng.randi() % BadNameSuffix.size()]
	return prefix + infix + suffix
