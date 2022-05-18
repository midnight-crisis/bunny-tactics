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
	"Olivia",
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

var BadNames = [
	"Jerma",
	"Grongle",
	"Romble",
	"Donkler",
	"Meano",
	"Swoobo",
	"Ranglo",
	"Spoompy",
	"Greg"
]

func generate_good_name():
	return GoodNames[Global.rng.randi() % GoodNames.size()]
	
func generate_bad_name():
	return BadNames[Global.rng.randi() % BadNames.size()]
