import subprocess

# Run the 'sinfo -R' command
process = subprocess.Popen(
    ["sinfo", "-R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
)
output, error = process.communicate()

# Check if the command executed successfully
if process.returncode != 0:
    print("Error executing command: ", error)
else:
    # Split the output by lines and parse each line
    nodes = [line.split()[-1] for line in output.strip().split("\n") if line]
    nodes = nodes[1:]
    print(" ".join(nodes))
    print(",".join(nodes))
