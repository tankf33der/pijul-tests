
# https://www.pythonforbeginners.com/basics/overwrite-a-file-in-python#htoc-overwrite-a-file-using-seek-and-truncate-method-in-python
with open('file.txt', 'r') as file:
    # Create an empty list to store the lines
    lines = []

    # Iterate over the lines of the file
    for line in file:
        # Remove the newline character at the end of the line
        line = line.strip()

        # Append the line to the list
        lines.append(line)

# Print the list of lines
print(lines)
