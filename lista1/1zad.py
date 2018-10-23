import sys

def search(T : str, P : str) -> list:
    m = 0
    i = 0
    results = []
    lps = find_lps(P)
    while m + i < len(T):
        if P[i] == T[m+i]:
            i += 1
            if i == len(P):
                results.append(m)
                m += 1
                # m = m + i
                i = 0
        else:
            m = m + i - lps[i]
            if i > 0:
                i = lps[i]
    for element in results:
        print("Znaleziono dopasowanie na indeksie ", element)
    return results

def find_lps(P : str) -> list:
    lps = []
    lps.append(-1)
    lps.append(0)
    i = 2
    j = 0
    while i < len(P):
        if P[i-1] == P[j]:
            lps.append(j+1)
            i += 1
            j += 1
        elif j > 0:
            j = lps[j]
        else:
            lps.append(0)
            i += 1
    return lps

# pattern = "asd"
# txt = "khbjasdjhbbjhbm sadasdasdasdasdmn asd"
# results = search(txt, pattern)

results = search(sys.argv[2], sys.argv[1])