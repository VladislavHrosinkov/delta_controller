import os
import pyperclip

def traverse_directory():
    current_directory = os.getcwd()
    concatenated_text = ""
    for root, dirs, files in os.walk(current_directory):
        for file in files:
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                file_text = f.read()
            concatenated_text += f"\n\n{file}\n\n{file_text}"
    return concatenated_text

def main():
    concatenated_text = traverse_directory()
    
    pyperclip.copy(concatenated_text)
    
    print(concatenated_text)

if __name__ == "__main__":
    main()

