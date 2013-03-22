cargarArchivo(Archivo,Lista):-
  seeing(Old),see(Archivo),read(Lista),seen,see(Old).
%---------------- FILTROS -------------------
u(par(F, C), par(NF, C)) :- NF is F+1.
d(par(F, C), par(NF, C)) :- NF is F-1.
r(par(F, C), par(F, NC)) :- NC is C+1.
l(par(F, C), par(F, NC)) :- NC is C-1.
dr(P, NP) :- d(P,Inter),r(Inter,NP).
dl(P, NP) :- d(P,Inter),l(Inter,NP).
ur(P, NP) :- u(P,Inter),r(Inter,NP).
ul(P, NP) :- u(P,Inter),l(Inter,NP).
%----------- FIN FILTROS -----------------------

%---- Buscar Letras -----
buscarLetras(_, _, _, []).
buscarLetras(Direccion, M, Par, [H|T]):-
  buscarLetra(M,Par,H),
  call(Direccion, Par, NuevoPar),
  buscarLetras(Direccion, M, NuevoPar, T).

  
buscarLetra(matriz(_,Filas),par(F,C),Elem):-
    nth0(F,Filas,Fila),
    nth0(C,Fila,Elem).
%---- FIN Buscar Letras -----  

% --- Funciones Aux -----
desglosarPalabras(Palabra, Acumulador, [Caracteres|Acumulador]):-
    atom_chars(Palabra,Caracteres).

desglosarLista(Lista,ListaDesglosada):-
  foldl(desglosarPalabras,Lista,[],ListaDesglosada).

chequearPalabra(Alfabeto,H):-
  atom_chars(H,Palabra), subset(Palabra,Alfabeto).

% --- FIN Funciones Aux -----

% ---- Rellenar la lista ------
rellenarLista(Tamano,NLista):-
  NTamano is Tamano * Tamano,
  rellanarAux(NTamano,[],NLista).
  

rellenarFila(0,Lista,Lista).
rellenarFila(T,Lista,Fila):-
  T>0,
  alfabeto(Q),
  append([Q],Lista,ListaParcial),
  NT is T-1,
  rellenarFila(NT,ListaParcial,Fila).
  
rellenarMatriz(0,Acumulador,Acumulador).
rellenarMatriz(T,Acumulador,Matriz):-
  T>0,
  rellenarFila(T,[],Fila),
  append(Acumulador, Fila,MP),
  NT is T -1,
  rellenarMatriz(NT,MP,Matriz).
  
rellanarAux(0,Lista,Lista).
rellanarAux(Tamano,Lista,NL):-
  Tamano > 0,
  alfabeto(X),
  append([X],Lista,NNL),
  NTamano is Tamano-1,
  rellanarAux(NTamano,NNL,NL).

  
% ----FIN Rellenar la lista ------



% ---- Lista a Matriz   ----
list_to_matrix_row(Tail, 0, [], Tail).
list_to_matrix_row([Item|List], Size, [Item|Row], Tail):-
  NSize is Size-1,
  list_to_matrix_row(List, NSize, Row, Tail).

list_to_matrix([], _, []).
list_to_matrix(List, Size, [Row|Matrix]):-
  list_to_matrix_row(List, Size, Row, Tail),
  list_to_matrix(Tail, Size, Matrix). 
% ---- FIN Lista a Matriz   ----

creaLista([]).
creaLista([H|T]) :-
        Argumento = [H],
        Funcion =.. [ alfabeto | Argumento],
        assert(Funcion),
        creaLista(T).
% ------ Mostrar Sopa -----   
%% Implantacion del predicado: mostrarSopaAux(L).
%% Este predicado triunfa si se logra imprimir
%% por pantalla una lista.
mostrarSopaAux([]).
mostrarSopaAux([H|T]) :- write(H),tab(1),mostrarSopaAux(T).

%% Implantacion del predicado: mostrarSopa(L).
%% Este predicado triunfa si se logra imprimir
%% la sopa de letras por pantalla
mostrarSopa([]).
mostrarSopa([H|T]) :- mostrarSopaAux(H),nl,mostrarSopa(T).
% ------ FIN  Mostrar Sopa -----  

crearSopa(_,_,[]).
crearSopa(Tamano,Sopa,Lista):-
  rellenarLista(Tamano,SopaTemporal),
  list_to_matrix(SopaTemporal,Tamano,Sopa),
  buscarLetras(u, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(d, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(r, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(l, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(dl, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(ul, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(dr, matriz(Tamano,Sopa), _,Lista)
  | buscarLetras(ur, matriz(Tamano,Sopa), _,Lista).

hacerSopa(Tamano,Sopa,Aceptada,Rechazada):-
  maplist(crearSopa(Tamano,Sopa),Aceptada),
  not(maplist(crearSopa(Tamano,Sopa),Rechazada)).

respuesta(mas):- fail.
respuesta(no):- nl,write('Gracias'),nl,halt. 

%% Implantacion del predicado: generadorSopa.
generadorSopa :-
  write('Introduzca el tamano de la sopa de letras a generar:'),
  read(Tamano),
  write('Introduzca el alfabeto de la sopa de letras:'),
  read(Alfabeto),
  creaLista(Alfabeto),
  write('Introduzca el archivo que contiene la lista de palabras a aceptar:'),
  read(ArchivoAceptado),
  write('Introduzca el archivo que contiene la lista de palabras a rechazar:'),
  read(ArchivoRechazado),
  cargarArchivo(ArchivoAceptado,ListaAceptados),
  cargarArchivo(ArchivoRechazado,ListaRechazados),
  maplist(chequearPalabra(Alfabeto),ListaAceptados),
  desglosarLista(ListaAceptados,Aceptada),
  desglosarLista(ListaRechazados,Rechazada),
  hacerSopa(Tamano,Sopa,Aceptada,Rechazada),
  mostrarSopa(Sopa),
  write('Quieres mas?'),
  nl,
  read(Respuesta),
  respuesta(Respuesta).
