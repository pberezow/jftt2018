#include <iostream>
#include <cstdlib>
#include <cstring>
using namespace std;

void find_lps(char* P, int* lps) {
    int P_len = strlen(P);
    lps[0] = -1;
    lps[1] = 0;
    int i = 2;
    int j = 0;

    while(i < P_len) {
        if(P[i-1] == P[j]) {
            lps[i] = j+1;
            i++;
            j++;
        }
        else if(j > 0) {
            j = lps[j];
        }
        else {
            lps[i] = 0;
            i++;
        }
    }
}

int* search(char* T, char* P) {
    int m = 0;
    int i = 0;
    int results = 0;
    int* results_array = (int*)calloc(1, sizeof(int));
    int T_len = strlen(T);
    int P_len = strlen(P);
    int* lps = (int*)calloc(P_len + 1, sizeof(int));

    find_lps(P, lps);

    while(m + i < T_len) {
        if(P[i] == T[m + i]) {
            i++;
            if(i == P_len) {
                results++;
                results_array = (int*)realloc(results_array, results * sizeof(int));
                results_array[results - 1] = m;
                m = m + i;
                i = 0;
            }
        }
        else {
            m = m + i - lps[i];
            if(i > 0) {
                i = lps[i];
            }
        }
    }
    for(int j = 0; j < results; j++) {
        cout << "Znaleziono dopasowanie na indeksie " << results_array[j] <<endl;
        // printf("Znaleziono dopasowanie na indeksie %d\n", results_array[j]);
    }
    return results_array;
}

int main(int argc, char**  argv) {
    char* P = argv[1];
    char* T = argv[2];
    search(T, P);
}