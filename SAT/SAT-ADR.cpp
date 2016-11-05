#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
#include <stack>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;//numVars+1 posicions (posicio 0 no es fa servir), resta T,F,U (True,False o Undefined) per a cada variable.
vector<int> modelStack;//numVars posicions. EX: 1/-4/3/2, amb cada variable que afegim al model.
int indexLastLit;//index a l'ultim literal afegit.
vector<int> decidedLits;//numVars pos. EX(de l'anterior): 1/2 -> de modelStack hem decidit el 1 i el 2 (la resta propagats).
int indexLastDecidedLit;//index a decidedLits de l'ultim literal decidid.
vector<vector<int> > posLitClauses;//clausules on apareix cada literal positivament. numVars+1 posicions (posicio 0 no es fa servir).
vector<vector<int> > negLitClauses;//clausules on apareix cada literal negativament. numVars+1 posicions (posicio 0 no es fa servir).
vector<int> sortedLits;//literals ordenats per nombre d'aparicions. numVars+1 posicions (posicio 0 no es fa servir).
stack<int> propagateStack;//pila de literals trobats per propagar.


//TMP
void writeClauses(){
    for(int i = 0; i < clauses.size(); ++i){
        for(int j = 0; j < clauses[i].size(); ++j){
            cout << clauses[i][j] << " ";
        }
        cout << "0" << endl;
    }
}

void writeSortedLits(){
    for(int i = 0; i < sortedLits.size(); ++i){
        cout << sortedLits[i] << " pos: " << posLitClauses[sortedLits[i]].size()
             << " neg: " << negLitClauses[sortedLits[i]].size() << endl;
    }
    cout << 0 << endl;
}

void writeModel(){
    for(int i = 0; i < model.size(); ++i){
        cout << i << ": " << model[i] << endl;
    }
    cout << 0 << endl;
}

void writeDecided(){
    for(int i = 0; i < decidedLits.size(); ++i){
        cout << i << ": " << decidedLits[i] << endl;
    }
    cout << 0 << endl;
}

void writeStack(){
    for(int i = 0; i < modelStack.size(); ++i){
        cout << i << ": " << modelStack[i] << endl;
    }
    cout << 0 << endl;
}
//FI TMP


void readClauses(){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  // Read clauses
  posLitClauses.resize(numVars+1);
  negLitClauses.resize(numVars+1);
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0){
        clauses[i].push_back(lit);
        if(lit > 0){
            posLitClauses[lit].push_back(i);
        }
        else{
            negLitClauses[-lit].push_back(i);
        }
    }
  }
}

//Particio del vector clauses
int partitionClauses(int lo, int hi){
    int p = rand()%(hi - lo + 1) + lo;
    int pivot = clauses[p].size();
    int i = lo - 1;
    int j = hi + 1;
    while(true){
        do{
            i++;
        }while(clauses[i].size() < pivot);
        do{
            j--;
        }while(clauses[j].size() > pivot);
        if(i >= j) return j;
        vector<int> tmp = clauses[i];
        clauses[i] = clauses[j];
        clauses[j] = tmp;
    }
}

//Quicksort del vector clauses
void quicksortClauses(int lo, int hi){
    if(lo < hi){
        int p = partitionClauses(lo, hi);
        quicksortClauses(lo, p);
        quicksortClauses(p + 1, hi);
    }
}

int partitionLits(int lo, int hi){
    int p = sortedLits[rand()%(hi - lo + 1) + lo];
    int pivot = posLitClauses[p].size();
    if(negLitClauses[p].size() > pivot){
        pivot = negLitClauses[p].size();
    }
    int sumPivot = posLitClauses[p].size()
                    + negLitClauses[p].size();
    int i = lo - 1;
    int j = hi + 1;
    while(true){
        int tmp;
        do{
            i++;
            tmp = posLitClauses[sortedLits[i]].size();
            if(negLitClauses[sortedLits[i]].size() > tmp)
                tmp = negLitClauses[sortedLits[i]].size();
        }while(tmp > pivot or
                (tmp == pivot and
                    (posLitClauses[sortedLits[i]].size() +
                        negLitClauses[sortedLits[i]].size()) > sumPivot));
        do{
            j--;
            tmp = posLitClauses[sortedLits[j]].size();
            if(negLitClauses[sortedLits[j]].size() > tmp)
                tmp = negLitClauses[sortedLits[j]].size();
        }while(tmp < pivot or
                (tmp == pivot and
                    (posLitClauses[sortedLits[j]].size() +
                        negLitClauses[sortedLits[j]].size()) < sumPivot));
        if(i >= j) return j;
        tmp = sortedLits[i];
        sortedLits[i] = sortedLits[j];
        sortedLits[j] = tmp;
    }
}

void quicksortLits(int lo, int hi){
    if(lo < hi){
        int p = partitionLits(lo, hi);
        quicksortLits(lo, p);
        quicksortLits(p + 1, hi);
    }
}

void initSortedLits(){
    sortedLits.resize(numVars+1);
    for(int i = 1; i < numVars+1; ++i){
        sortedLits[i] = i;
    }
    quicksortLits(1, numVars);
}

int currentValueInModel(int lit){
    if (lit >= 0) return model[lit];
    else {
        if (model[-lit] == UNDEF) return UNDEF;
        else return 1 - model[-lit];
    }
}

//Dona el valor que pertoqui al literal a afegir a la pila i apunta al nou literal.
void setLiteralToTrue(int lit){
    ++indexLastLit;
    modelStack[indexLastLit] = lit;
    //*CHI*/cout << "setLitToTrue " << lit << " a " << indexLastLit << endl;
    if (lit > 0){
        model[lit] = TRUE;
    }
    else{
        model[-lit] = FALSE;
    }
    //*CHI*/cout << model[abs(lit)] << endl;
}

bool propagate(int lit){
    //*CHI*/cout << "propagant " << lit << endl;
    vector<vector<int> > *litClauses = &negLitClauses;
    if(lit < 0){
        lit = -lit;
        litClauses = &posLitClauses;
    }
    for(int i = 0; i < (*litClauses)[lit].size(); ++i){
        int countUndef = 0;
        int lastUndef = 0;
        bool someTrue = false;
        int clauseIndex = (*litClauses)[lit][i];
        //*CHI*/int clauseTmp = -1;
        for(int j = 0; j < clauses[clauseIndex].size(); ++j){
            int val = currentValueInModel(clauses[clauseIndex][j]);
            if(val == TRUE) someTrue = true;
            else if(val == UNDEF){
                ++countUndef;
                lastUndef = clauses[clauseIndex][j];
                //*CHI*/clauseTmp = clauseIndex;
            }
        }
        if(not someTrue and countUndef == 0){
            //*CHI*/cout << "conf trobat propagant des de " << lit << endl;
            return false;//conflict, need backtrack.
        }
        else if(not someTrue and countUndef == 1){//Hem trobat per on propagar altre cop.
            propagateStack.push(lastUndef);
            setLiteralToTrue(lastUndef);//Afegeix lit a modelStack (i augmenta apuntador corresponent).
            //*CHI*/cout << "afegit a propSTack lit " << lastUndef << " per clausula " << clauseTmp << endl;
        }
    }    
    //*CHI*/cout << "fi prop de " << lit << endl;
    return true;
}

int backtrack(){
    if(indexLastDecidedLit < 0) return 0;
    while(modelStack[indexLastLit] != decidedLits[indexLastDecidedLit]){
        model[abs(modelStack[indexLastLit])] = UNDEF;
        //*CHI*/cout << "bck " << abs(modelStack[indexLastLit]) << " possat a " << model[abs(modelStack[indexLastLit])] << endl;
        --indexLastLit;
    }
    --indexLastLit;
    int lit = -decidedLits[indexLastDecidedLit];
    //*CHI*/cout << "fet backtracking fins a " << -lit << endl;
    setLiteralToTrue(lit);
    //*CHI*/cout << "acabat backtracking" << endl;
    --indexLastDecidedLit;
    return lit;
}

// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
    // stupid heuristic:
    for (uint i = 1; i <= numVars; ++i){
        // returns first UNDEF var, positively or neg. Lits ordered by appearances.
        if (model[sortedLits[i]] == UNDEF){
                int retVal = sortedLits[i];
                if(negLitClauses[retVal].size() > posLitClauses[retVal].size()){
                    retVal = -retVal;
                }
                return retVal;
        }
    }
    return 0; // reurns 0 when all literals are defined
}

void checkmodel(){
    for (int i = 0; i < numClauses; ++i){
        bool someTrue = false;
        for (int j = 0; not someTrue and j < clauses[i].size(); ++j)
            someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
        if (not someTrue) {
            cout << "Error in model, clause is not satisfied:";
            for (int j = 0; j < clauses[i].size(); ++j)
                    cout << clauses[i][j] << " ";
            cout << endl;
            //*CHI*/writeModel();
            //*CHI*/cout << endl << "indDec: " << indexLastDecidedLit << endl;
            //*CHI*/writeDecided();
            //*CHI*/cout << endl << "indStack " << indexLastLit << endl;
            //*CHI*/writeStack();
            exit(1);
        }
    }
}

//Funcio per fer clear eficient de stack
void clear( stack<int> &s ){
   std::stack<int> empty;
   std::swap( s, empty );
}

int main(){
    srand(time(NULL));//rand seed
    readClauses();// reads numVars, numClauses and clauses & posLitClauses & negLitClauses.
    //quicksortClauses(0, clauses.size()); //ordena clausules de menys a mes variables. innecesari?
    model.resize(numVars+1,UNDEF);
    modelStack.resize(numVars,0);
    indexLastLit = -1;
    decidedLits.resize(numVars,0);
    indexLastDecidedLit = -1;
    initSortedLits();

    int nextLitProp;

    //*CHI*/cout << "Initial unit clauses" << endl;
    
    // Take care of initial unit clauses, if any
    for (uint i = 0; i < numClauses; ++i){
        if (clauses[i].size() == 1) {
            nextLitProp = clauses[i][0];
            int val = currentValueInModel(nextLitProp);
            if (val == UNDEF){
                setLiteralToTrue(nextLitProp);
                propagateStack.push(nextLitProp);
                while(not propagateStack.empty()){
                    nextLitProp = propagateStack.top();
                    propagateStack.pop();
                    if(not propagate(nextLitProp)){
                        cout << "UNSATISFIABLE" << endl;
                        return 10;
                    }
                }
            }
        }
    }
    
    //*CHI*/cout << "END initial unit clauses" << endl;

    // DPLL algorithm
    while(true) {

        //Decisió de lits.
        nextLitProp = getNextDecisionLiteral();
        if(nextLitProp == 0) {
            checkmodel();
            cout << "SATISFIABLE" << endl;
            //*CHI*/writeModel();
            //*CHI*/cout << endl << endl;
            //*CHI*/writeDecided();
            //*CHI*/cout << endl << endl;
            //*CHI*/writeStack();
            return 20;
        }
        // start new decision level:
        setLiteralToTrue(nextLitProp);//Afegeix lit a modelStack (i augmenta apuntador corresponent).   
        //Afegeix a decidedLit i augmentar apuntador.
        ++indexLastDecidedLit;
        decidedLits[indexLastDecidedLit] = nextLitProp;
        //*CHI*/cout << "Afegit decision " << nextLitProp << " a " << indexLastDecidedLit << endl;
        //Prepara propagateStack
        propagateStack.push(nextLitProp);

        //Propagacio.
        while(not propagateStack.empty()){
            nextLitProp = propagateStack.top();
            propagateStack.pop();
            if(not propagate(nextLitProp)){
                //Si troba conflicte, prova a fer backtracking.
                nextLitProp = backtrack();
                if(nextLitProp == 0){
                    //En cas de no poder fer el backtracking INSAT.
                    cout << "UNSATISFIABLE" << endl;
                    return 10;
                }
                clear(propagateStack);
                propagateStack.push(nextLitProp);
            }                 
        }
        clear(propagateStack);//Per si hi ha hagut una fallada i queda algo a la pila

    }

}




/*IDEES:

- Ordenar per tamany de clausules on apareix un lit tambe! (mitjana o algo per l'estil).

- VSIDS. (Anar "resetejant" punts, els mes "propers" temporalment tenen MES importancia! (anar dividint per 2 les puntuacions cada X temps, per exemple))

*/