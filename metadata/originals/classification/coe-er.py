#!/usr/bin/env python3
from sys import stderr

def cleanup(s):
    for rm in ["(continued)", "subg.", "sect.", "ser.", "subser."]:
        s = s.replace(rm, "")
    return '"' + s.strip() + '"'

correct_cells = 0
def output(cells):
    global correct_cells
    if correct_cells == 0:
        correct_cells = len(cells)
    cells = list(map(cleanup, cells))
    if len(cells) != correct_cells:
        for i in range(correct_cells - len(cells)):
            cells.append("")
    print(*cells,sep="\t")

def main(dbfile):
    with open(dbfile) as fh:
        lines = [l.rstrip() for l in fh]
    genus = subg = sect = series =subser = species = subsp = ""
    #output(["Genus", "GenusCommon", "Subgenus", "SubgenusCommon", "Section",
    #        "SectionCommon", "Series", "SeriesCommon", "Subseries",
    #        "SubseriesCommon", "Species", "SpeciesCommon", "Subspecies",
    #        "SubspeciesCommon", "NativeRange", "DN_Observed", "DN_Collected",
    #        "CCA_Status", "Synonyms"])
    output(["Genus", "Subgenus", "Section", "Series", "Subseries", "Species",
            "Subspecies", "NativeRange", "DN_Observed", "DN_Collected",
            "CCA_Status", "Synonyms"])
    for line in lines:
        line_orig = line
        line = line.strip()
        if not line_orig.startswith(" "):
            genus = line[:line.find("   ")] if "   " in line else line
            subg = sect = series =subser = species = subsp = ""
        elif line.startswith("subg."):
            subg = line[:line.find("   ")] if "   " in line else line
            sect = series =subser = species = subsp = ""
        elif line.startswith("sect."):
            sect = line[:line.find("   ")] if "   " in line else line
            series = subser = species = subsp = ""
        elif line.startswith("ser."):
            series = line[:line.find("   ")] if "   " in line else line
            subser = species = subsp = ""
        elif line.startswith("subser."):
            subser = line[:line.find("   ")] if "   " in line else line
            species = subsp = ""
        else:
            cells = line.strip().split("\t")
            if len(cells) == 1:
                sp, _, syn = cells[0].partition("    ")
                cells = [sp, "", "", "", "", syn]
            if line.lstrip("? ").startswith("subsp.") or \
                line.lstrip("? ").startswith("var."):
                subsp = cells[0].strip()
            else:
                species = cells[0].strip()
                subsp = ""
            cells = [genus, subg, sect, series, subser, species, subsp, *cells[1:]]
            output(cells)


if __name__ == "__main__":
    from sys import argv, exit, stderr
    if len(argv) != 2:
        print("USAGE:", argv[0], "DB_FILE", file=stderr)
        exit(1)
    main(argv[1])

