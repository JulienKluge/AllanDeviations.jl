using Documenter, AllanDeviations

makedocs(
	format = :html,
    sitename = "AllanDeviations",
    authors = "Julien Kluge",
    pages = [
        "Home" => "index.md",
        "Installation Guide" => "installation.md",
        "Quick Start Guide" => "quickstart.md",
        "Library" => Any[
			"API guide" => "lib/apiguide.md",
			"Allan Deviation" => "lib/allandev.md",
			"Modified Allan Deviation" => "lib/mallandev.md",
			"Hadamard Deviation" => "lib/hadamarddev.md",
			"Time Deviation" => "lib/timedev.md",
			"Total Deviation.md" => "lib/totaldev.md"
		]
    ],
    assets = [
        "assets/AllanDeviationsLogo.png"
    ]
)