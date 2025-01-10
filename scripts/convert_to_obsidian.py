import argparse
import glob
import os
import os.path as osp
import re
import shutil
from dataclasses import dataclass
from typing import Dict, List, Optional

# OBSIDIAN_PATH = (
#     "/Users/andrewszot/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal"
# )
OBSIDIAN_PATH = "/Users/andrewszot/Documents/obsidian/PersonalTest"


def clean_name(x: str):
    x = x.replace("/", "")
    x = x.replace("\\", "")
    x = x.replace("$", "")
    x = x.strip()
    return x


def replace_I_with_intuition(text):
    result = []
    i = 0
    while i < len(text):
        if text[i : i + 3] == "{I}":
            # Remove the preceding 15 characters and the next character
            start = max(0, len(result) - 16)
            result = result[:start]
            result.append("(Intuition)")
            i += 4  # Skip "{I}" and the next character
        else:
            result.append(text[i])
            i += 1
    return "".join(result)


def clean_content(x: str) -> str:
    x = replace_I_with_intuition(x)

    lines = x.split("\n")
    bad_line_elements = [
        "begin{enumerate}",
        "end{enumerate}",
        "begin{itemize}",
        "end{itemize}",
        "Cref",
    ]
    lines = [line for line in lines if not any(x in line for x in bad_line_elements)]
    lines = [line for line in lines if not line.startswith("%")]
    x = "\n".join(lines)

    x = x.replace("      \\item", "  * ")
    x = x.replace("  \\item ", "* ")
    x = x.replace("\\item ", "* ")

    # Surround \begin{align*} ... \end{align*} with $$
    x = re.sub(
        r"\\begin\{align\*\}(.*?)\\end\{align\*\}",
        r"$$\\begin{align}\1\\end{align}$$",
        x,
        flags=re.DOTALL,
    )

    # Convert \emph{x} to markdown _x_
    x = re.sub(r"\\emph\{(.*?)\}", r"_\1_", x)

    # Convert \textbf{x} to markdown **x**
    x = re.sub(r"\\textbf\{(.*?)\}", r"**\1**", x)

    x = re.sub(r"\\section\{(.*?)\}", r"# \1", x)
    x = re.sub(r"\\subsection\{(.*?)\}", r"## \1", x)
    x = re.sub(r"\\subsubsection\{(.*?)\}", r"### \1", x)

    # Strip leading and trailing whitespace
    x = x.strip()

    remaps = {
        "\\Vol": "\\text{Vol}",
        "\\Vol": "\\text{Vol}",
        "\\Dm": "\\text{dim}",
        "\\Tr": "\\text{tr}",
        "\\Sn": "\\text{sign}",
        "\\Supp": "\\text{supp}",
        "\\Imag": "\\text{Im}",
        "\\Rea": "\\text{Re}",
        "\\Real": "\\text{Re}",
        "\\Ind": "\\text{Ind}",
        "\\It": "\\text{Int}",
        "\\Ext": "\\text{Ext}",
        "\\Arg": "\\text{arg}",
        "\\rng": "\\text{ran}",
        "\\cis": "\\text{cis}",
        "\\dom": "\\text{dom}",
        "\\Rng": "\\text{Range}",
        "\\Dom": "\\text{Dom}",
        "\\An": "\\text{ann}",
        "\\Res": "\\text{Res}",
        "\\Mod": "\\text{mod}",
        "\\Dg": "\\text{deg}",
        "\\Diam": "\\text{Diam}",
        "\\Ima": "\\text{Img}",
        "\\Ker": "\\text{Ker}",
        "\\Id": "\\text{Id}",
        "\\Span": "\\text{span}",
        "\\Row": "\\text{row}",
        "\\Col": "\\text{col}",
        "\\Nul": "\\text{Nul}",
        "\\Dt": "\\text{det}",
        "\\Rank": "\\text{rank}",
        "\\Srank": "\\text{srank}",
        "\\rank": "\\text{rank}",
        "\\srank": "\\text{srank}",
        "\\Dist": "\\text{dist}",
        "\\Aff": "\\text{aff}",
        "\\Cvx": "\\text{conv}",
        "\\relu": "\\text{relu}",
        "\\Tv": "\\text{TV}",
        "\\sech": "\\text{sech}",
        "\\Med": "\\text{med}",
        "\\Var": "\\text{Var}",
        "\\Cov": "\\text{Cov}",
        "\\Unf": "\\text{Unif}",
        "\\Bern": "\\text{Bern}",
        "\\Pois": "\\text{Pois}",
        "\\Ast": "\\ast",
        "\\io ": "i.o.",
        "\\as ": "a.s.",
        "\\ae ": "a.e.",
        "\\io$": "\\text{ i.o.}$",
        "\\as$": "\\text{ a.s.}$",
        "\\ae$": "\\text{ a.e.}$",
        "\\dd ": "d",
        "\\mathbbm": "\\mathbb",
        "\\argmin": "\\text{argmin}",
        "``": '"',
    }
    for old_k, new_k in remaps.items():
        x = x.replace(old_k, new_k)

    x = re.sub(r"\\io(?=[\s\n$])", r"\\textbf{ i.o.}", x)
    x = re.sub(r"\\as(?=[\s\n$])", r"\\textbf{ a.s.}", x)
    x = re.sub(r"\\ae(?=[\s\n$])", r"\\textbf{ a.e.}", x)

    x = replace_operator_with_custom_braces(x, "abs", "\\lvert ", " \\rvert")
    x = replace_operator_with_custom_braces(x, "norm", "\\lVert ", " \\rVert")
    x = replace_operator_with_custom_braces(x, "ceil", "\\lceil ", " \\rceil")
    x = replace_operator_with_custom_braces(x, "flr", "\\lfloor ", " \\rfloor")

    lines = x.splitlines()
    processed_lines = [
        line.lstrip() if not line.lstrip().startswith("*") else line for line in lines
    ]
    x = "\n".join(processed_lines)

    x = remove_whitespace_between_dollars(x)

    return x


def replace_operator_with_custom_braces(text, operator, left_replace, right_replace):
    result = []
    i = 0
    operator_pattern = f"\\{operator}*"
    while i < len(text):
        if text[i : i + len(operator_pattern)] == operator_pattern:
            result.append(left_replace)
            i += len(operator_pattern)
            if i < len(text) and text[i] == "{":
                brace_count = 1
                i += 1
                while i < len(text) and brace_count > 0:
                    if text[i] == "{":
                        brace_count += 1
                    elif text[i] == "}":
                        brace_count -= 1
                        if brace_count == 0:
                            break
                    result.append(text[i])
                    i += 1
                result.append(right_replace)
        else:
            result.append(text[i])
        i += 1
    return "".join(result)


def remove_whitespace_between_dollars(text):
    result = []
    inside_dollars = False
    i = 0
    ignore_punc = ["-", ",", ".", "!", "?"]

    while i < len(text):
        if text[i] == "$":
            if inside_dollars:
                if result and result[-1] == " ":
                    result.pop()
                result.append("$")
                if (
                    i + 1 < len(text)
                    and text[i + 1] not in ignore_punc
                    and text[i + 1] != " "
                ):
                    result.append(" ")
                inside_dollars = False
            else:
                if result and result[-1] != " " and result[-1] not in ignore_punc:
                    result.append(" ")
                result.append("$")
                inside_dollars = True
                i += 1
                while i < len(text) and text[i] == " ":
                    i += 1
                continue
        else:
            result.append(text[i])
        i += 1

    return "".join(result)


@dataclass
class EntityInfo:
    name: str  # The name of the theorem of definition.
    content: str  # The content of the theorem or definition.
    entity_type: str  # theorem or definition
    expl: Optional[str]  # The explanation content (optional).
    proof: Optional[str]  # The proof content (optional).
    entity_id: str


def clean_link(x: str, id_to_entity):
    while True:
        matches = list(re.finditer(r"\\href\{(.*?)\}\{(.*?)\}", x))
        if len(matches) == 0:
            break
        match = matches[0]

        match_id = match.group(1)
        if match_id.startswith("./"):
            match_id = match_id[len("./") :]
        add_content = ""
        ref = match.group(2).split(" ")
        if match_id == "math_encyclopedia/intro_to_topo_manifolds.tex":
            sub_name = "Lee, Introduction to Topological Manifolds"
            add_content = " " + " ".join(ref[1:])
        elif match_id == "math_encyclopedia/conway.tex":
            sub_name = "Conway, Functions of One Complex Variable I"
            add_content = " " + " ".join(ref[1:])
        elif match_id == "math_encyclopedia/royden_analysis.tex":
            sub_name = "Royden, Real Analysis"
            add_content = " " + " ".join(ref[1:])
        elif match_id not in id_to_entity:
            sub_name = match_id
            if "http" not in match_id:
                print(f"Unmatched ID {match_id}")
        else:
            sub_name = id_to_entity[match_id].name
        span = match.span(0)
        x = x[: span[0]] + f"[[{sub_name}]]" + add_content + x[span[1] :]
    return x


def clean_links(entity: EntityInfo, id_to_entity) -> EntityInfo:
    entity.content = clean_link(entity.content, id_to_entity)
    if entity.expl:
        entity.expl = clean_link(entity.expl, id_to_entity)
    if entity.proof:
        entity.proof = clean_link(entity.proof, id_to_entity)
    return entity


def clean_entity_info(entity: EntityInfo) -> EntityInfo:
    entity.content = clean_content(entity.content)
    if entity.expl:
        entity.expl = clean_content(entity.expl)
    if entity.proof:
        entity.proof = clean_content(entity.proof)
    entity.name = clean_name(entity.name)

    return entity


def clean_text_entity_info(entity):
    entity.content = clean_content(entity.content)
    entity.name = clean_name(entity.name)

    return entity


def parse_content(content: str) -> List[EntityInfo]:
    entities = []
    # Pattern for theorems and definitions
    main_pattern = r"\\begin\{(mytheo|mydef)\}\{(.+?)\}\{(.+?)\}(.*?)\\end\{\1\}"
    # Pattern for explanations
    expl_pattern = r"\n\\begin\{expl\}\{.*?\}(.*?)\\end\{expl\}"
    # Pattern for proofs
    proof_pattern = r"\n\\begin\{proof\}(.*?)\\end\{proof\}"

    pos = 0  # Position to track parsing progress in the content

    while pos < len(content):
        # Match theorem or definition
        main_match = re.search(main_pattern, content[pos:], re.DOTALL)
        if not main_match:
            break

        entity_type, name, identifier, entity_main_content = main_match.groups()
        entity_type = "theorem" if entity_type == "mytheo" else "definition"
        name = name.strip()
        identifier = identifier.strip()
        entity_main_content = entity_main_content.strip()

        # Update the position after the matched theorem/definition
        pos += main_match.end()

        # Initialize explanation and proof as None
        expl = None
        proof = None

        # Match explanation if it exists
        expl_match = re.match(expl_pattern, content[pos:], re.DOTALL)
        if expl_match:
            expl = expl_match.group(1)
            expl = "}".join(expl.split("}")[1:])
            expl = expl.strip()
            pos += expl_match.end()  # Move position forward after explanation

        # Match proof if it exists
        proof_match = re.match(proof_pattern, content[pos:], re.DOTALL)
        if proof_match:
            proof = proof_match.group(1).strip()
            pos += proof_match.end()  # Move position forward after proof

        # Add the parsed entity to the list
        entities.append(
            EntityInfo(
                name=name,
                content=entity_main_content,
                entity_type=entity_type,
                expl=expl,
                proof=proof,
                entity_id=identifier,
            )
        )

    return entities


@dataclass
class TextEntityInfo:
    content: str
    tags: Dict[str, str]
    name: str
    entity_id: str


def parse_text_content(content: str, file) -> TextEntityInfo:
    parts = content.split("\n")
    first_line = parts[0]
    content = "\n".join(parts[1:])

    metadata_pattern = r"%@ (.+?): (.+)"
    metadata = dict(re.findall(metadata_pattern, content))

    title_pattern = r"%@ (.+)"
    title_matches = re.findall(title_pattern, first_line)
    if len(title_matches) == 0:
        return None
    title = title_matches[0]

    content_start = content.find("\\maketitle") + len("\\maketitle")
    content_end = content.find("\\end{document}")
    document_content = content[content_start:content_end].strip()

    return TextEntityInfo(
        name=title,
        content=document_content,
        tags={k: v for k, v in metadata.items()},
        entity_id=file[len("/Users/andrewszot/me/") :],
    )


def convert_file(file, search_dir, is_text):
    out_name = osp.basename(file).split(".")[0]
    if is_text:
        all_entities, id_to_entity = get_all_text_entities(search_dir)
    else:
        all_entities, id_to_entity = get_all_entities(search_dir)

    with open(file, "r", encoding="utf-8") as f:
        content = f.read()
    content = content.split("maketitle")[1]
    content = clean_content(content)
    content = clean_link(content, id_to_entity)

    write_path = osp.join(OBSIDIAN_PATH, "summary", out_name) + ".md"
    with open(write_path, "w") as f:
        f.write(content)


def get_all_entities(search_dir):
    all_entities = []

    for file in glob.iglob(osp.join(search_dir, "**"), recursive=True):
        if not osp.isfile(file):
            continue
        if "~" in file:
            continue
        if not (file.endswith(".tex") or file.endswith(".md")):
            continue

        with open(file, "r", encoding="utf-8") as f:
            content = f.read()
        all_entities.extend(parse_content(content))

    all_entities = [clean_entity_info(x) for x in all_entities]
    id_to_entity = {entity.entity_id: entity for entity in all_entities}
    all_entities = [clean_links(x, id_to_entity) for x in all_entities]
    return all_entities, id_to_entity


def get_all_text_entities(search_dir):
    all_entities = []

    for file in glob.iglob(osp.join(search_dir, "**"), recursive=True):
        if not osp.isfile(file):
            continue
        if "~" in file:
            continue
        if not (file.endswith(".tex") or file.endswith(".md")):
            continue
        if "/index.tex" in file:
            continue

        with open(file, "r", encoding="utf-8") as f:
            content = f.read()
        add_entity = parse_text_content(content, file)
        if add_entity is None:
            print(f"Failed to parse {file}")
            continue
        all_entities.append(add_entity)

    all_entities = [clean_text_entity_info(x) for x in all_entities]
    id_to_entity = {entity.entity_id: entity for entity in all_entities}
    for entity in all_entities:
        entity.content = clean_link(entity.content, id_to_entity)

    return all_entities, id_to_entity


def convert_dir(search_dir):
    target_dir = osp.join(OBSIDIAN_PATH, osp.basename(search_dir))
    if osp.exists(target_dir):
        shutil.rmtree(target_dir, ignore_errors=True)
    os.makedirs(target_dir, exist_ok=True)

    all_entities, id_to_entity = get_all_entities(search_dir)

    for entity in all_entities:
        write_entity_to_file(entity, target_dir)


def convert_text_dir(search_dir):
    target_dir = osp.join(OBSIDIAN_PATH, osp.basename(search_dir))
    if osp.exists(target_dir):
        shutil.rmtree(target_dir, ignore_errors=True)
    os.makedirs(target_dir, exist_ok=True)

    all_entities, id_to_entity = get_all_text_entities(search_dir)

    for entity in all_entities:
        write_text_entity_to_file(entity, target_dir)


def write_text_entity_to_file(entity, directory: str):
    file_path = os.path.join(directory, f"{entity.name}.md")

    with open(file_path, "w", encoding="utf-8") as f:
        f.write("---\n")
        for k, v in entity.tags.items():
            f.write(f"{k}: {v}\n")
        f.write("---\n")
        # Write the main content
        f.write(entity.content)


def write_entity_to_file(entity: EntityInfo, directory: str):
    file_path = os.path.join(directory, f"{entity.name}.md")

    with open(file_path, "w", encoding="utf-8") as f:
        f.write("---\n")
        f.write(f"tags:\n  - {entity.entity_type}\n")
        f.write("---\n")
        # Write the main content
        f.write(entity.content)

        # Add Intuition section if available
        if entity.expl:
            f.write("\n\n**Intuition**\n")
            f.write(entity.expl)

        # Add Proof section if available
        if entity.proof:
            f.write("\n\n**Proof**\n")
            f.write(entity.proof)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--convert-dir", default=None, type=str)
    parser.add_argument("--convert-file", default=None, type=str)
    parser.add_argument("--convert-text-dir", default=None, type=str)
    args = parser.parse_args()
    if args.convert_file is not None:
        if args.convert_text_dir is None:
            convert_file(args.convert_file, args.convert_dir, False)
        else:
            convert_file(args.convert_file, args.convert_text_dir, True)
    elif args.convert_text_dir is not None:
        convert_text_dir(args.convert_text_dir)
    else:
        convert_dir(args.convert_dir)
