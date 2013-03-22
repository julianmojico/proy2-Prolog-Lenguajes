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
rellenarLista(Tamano,Lista,NLista):-
  NTamano is Tamano * Tamano,
  rellanarAux(NTamano,Lista,NLista).
  
  
rellanarAux(Tamano,Lista,NL):-
  length(Lista,TActual),
  ( ( Tamano >= TActual) ->
      Falta is Tamano - TActual,
      sacarAleatoriosLista(Lista,Falta,Resto),
      append(Lista,Resto,NL);
      Sobra is TActual - Tamano,
      sacarAleatoriosLista(Lista,Sobra,NL)).

% ----FIN Rellenar la lista ------


% --- Aleatorios Lista ---------
sacarAleatoriosLista(_,0,[]).
sacarAleatoriosLista(Lista,Tamano,[H|T]) :- 
    Tamano > 0,
    length(Lista,L),
    R is random(L) + 1,
    remover(H,Lista,R,_),
    NTamano is Tamano - 1,
    sacarAleatoriosLista(Lista,NTamano,T).
    
remover(X,[X|Xs],1,Xs).
remover(X,[Y|Xs],K,[Y|Ys]) :-
   K > 1, 
   K1 is K - 1,
   remover(X,Xs,K1,Ys).
% --- FIN Aleatorios Lista ---------  

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


crearSopa(Tamano,Alfabeto,Sopa,Lista):-
  rellenarLista(Tamano,Alfabeto,NL),
  permutation(NL,NLP), 
  list_to_matrix(NLP,Tamano,Sopa),
  buscarLetras(r, matriz(Tamano,Sopa), _, Lista)
  | buscarLetras(l, matriz(Tamano,Sopa), _, Lista)
  | buscarLetras(d, matriz(Tamano,Sopa), _, Lista)
  | buscarLetras(u, matriz(Tamano,Sopa), _, Lista).
  



%% Implantacion del predicado: generadorSopa.
generadorSopa :-
  write('Introduzca el tamano de la sopa de letras a generar:'),
  read(Tamano),
  write('Introduzca el alfabeto de la sopa de letras:'),
  read(Alfabeto),
  write('Introduzca el archivo que contiene la lista de palabras a aceptar:'),
  read(ArchivoAceptado),
  write('Introduzca el archivo que contiene la lista de palabras a rechazar:'),
  read(ArchivoRechazado),
  cargarArchivo(ArchivoAceptado,ListaAceptados),
  %write(ListaAceptados),
  cargarArchivo(ArchivoRechazado,ListaRechazados),
  maplist(chequearPalabra(Alfabeto),ListaAceptados),
  desglosarLista(ListaAceptados,Aceptada),
  %crearSopa(Tamano,Alfabeto,Sopa,Aceptada),
  maplist(crearSopa(Tamano,Alfabeto,Sopa),Aceptada),
  %desglosarLista(ListaAceptados,Aceptada),
  desglosarLista(ListaRechazados,Rechazada),
  mostrarSopa(Sopa).
  %% Primero filtramos las palabras que no deberian estar
  %% para mejorar la eficiencia.
  %maplist(buscarLetras(r,matriz(Tamano,Sopa),_),ListaAceptados).