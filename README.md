# MatlabFileOperation

## Extract duplicate files
### filterDuplicateFiles.m
1. Extract all files in current directory and its subfolders.
2. Count files with the same name, date or size.
3. Reserve one of them, and move the others to one cache directory with writing its initial directory to txt file.
*herefiles(): return all the files in the specified directory.*

### picCompLoop.m
1. Filter all pictures in the specified directory.
2. Try to rename them with number.
3. Show two of them in one figure.
4. Click to the one you prefer. Or delete the one you hate.
5. The one you like best would be renamed as a small number.
*herefile(): return the specified format file from the specified directory.*