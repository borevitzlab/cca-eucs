#!/usr/bin/env python3

def cleanup(s):
    for rm in ["(continued)", "subg.", "sect.", "ser.", "subser."]:
        s = s.replace(rm, "")
    return s.strip()

def main(dbfile):
    with open(dbfile) as fh:
        lines = [l.rstrip("\n") for l in fh]
    genus = subg = sect = series =subser = species = subsp = ""
    print("Genus", "Subgenus", "Section", "Series", "Subseries", "Species",
          "Subspecies", "NativeRange", "DN_Observed", "DN_Collected", "CCA_Status",
          "Synonyms", sep="\t")
    for line in lines:
        if not line.startswith(" "):
            genus = line[:line.find("   ")] if "   " in line else line
            subg = sect = series =subser = species = subsp = ""
        elif line.lstrip().startswith("subg."):
            subg = line[:line.find("   ")] if "   " in line else line
            sect = series =subser = species = subsp = ""
        elif line.lstrip().startswith("sect."):
            sect = line[:line.find("   ")] if "   " in line else line
            series =subser = species = subsp = ""
        elif line.lstrip().startswith("ser."):
            series = line[:line.find("   ")] if "   " in line else line
            subser = species = subsp = ""
        elif line.lstrip().startswith("subser."):
            subser = line[:line.find("   ")] if "   " in line else line
            species = subsp = ""
        elif line.lstrip("? ").startswith("subsp.") or \
                line.lstrip("? ").startswith("var."):
            line=line.strip()
            cells = line.strip().split("\t")
            if len(cells) == 1:
                sp, _, syn = cells[0].partition("    ")
                cells = [sp, "", "", "", "", syn]
            subsp = cells[0].strip()
            cells = map(cleanup, [genus, subg, sect, series, subser, species,
                                  subsp, *cells[1:]])
            print(*cells,sep="\t")
        else:
            cells = line.strip().split("\t")
            if len(cells) == 1:
                sp, _, syn = cells[0].partition("    ")
                cells = [sp, "", "", "", "", syn]
            species = cells[0].strip()
            subsp = ""
            cells = map(cleanup, [genus, subg, sect, series, subser, species,
                                  subsp, *cells[1:]])
            print(*cells,sep="\t")


if __name__ == "__main__":
    from sys import argv, exit, stderr
    if len(argv) != 2:
        print("USAGE:", argv[0], "DB_FILE", file=stderr)
        exit(1)
    main(argv[1])

