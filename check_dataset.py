import os

safe_path = "dataset/safe"
not_safe_path = "dataset/not_safe"

print("Safe images:", len(os.listdir(safe_path)))
print("Not safe images:", len(os.listdir(not_safe_path)))