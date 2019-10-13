import sys
if __name__ == "__main__":
    if len(sys.argv) >= 2:
        file_name = sys.argv[1]
        start=387
        f = open(file_name)
        s = f.read()
        print(s[start:start+10].strip())
    else:
        print('File name is required. Got %s args. Ex: python papi_extract.py <FILE>' % len(sys.argv))