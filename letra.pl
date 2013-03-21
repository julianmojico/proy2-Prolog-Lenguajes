cargarArchivo(Archivo,Lista):-
  seeing(Old),see(Archivo),read(Lista),seen,see(Old).
  
list_to_matrix_row(Tail, 0, [], Tail).
list_to_matrix_row([Item|List], Size, [Item|Row], Tail):-
  NSize is Size-1,
  list_to_matrix_row(List, NSize, Row, Tail).
  
  
list_to_matrix([], _, []).
list_to_matrix(List, Size, [Row|Matrix]):-
  list_to_matrix_row(List, Size, Row, Tail),
  list_to_matrix(Tail, Size, Matrix).  
%%pertenece([],_). 
%%pertenece([H|T],Alfabeto):-
 %%member(H,Alfabeto),pertenece(T,Alfabeto).

u(par(F, C), par(NF, C)) :- NF is F+1.
d(par(F, C), par(NF, C)) :- NF is F-1.
r(par(F, C), par(F, NC)) :- NC is C+1.
l(par(F, C), par(F, NC)) :- NC is C-1.
dr(P, NP) :- d(P,Inter),r(Inter,NP).
dl(P, NP) :- d(P,Inter),l(Inter,NP).
ur(P, NP) :- u(P,Inter),r(Inter,NP).
ul(P, NP) :- u(P,Inter),l(Inter,NP).

remove_at(X,[X|Xs],1,Xs).
remove_at(X,[Y|Xs],K,[Y|Ys]) :-
   K > 1, 
   K1 is K - 1,
   remove_at(X,Xs,K1,Ys).

crearSopa(Tamano,Alfabeto,Sopa):-
  permutation(Alfabeto,SopaTemporal),
  list_to_matrix(SopaTemporal,Tamano,Sopa).




buscarLetras(_, _, _, []).
buscarLetras(Direccion, M, Par, [H|T]):-
  buscarLetra(M,Par,H),
  call(Direccion, Par, NuevoPar),
  buscarLetras(Direccion, M, NuevoPar, T).

  
buscarLetra(matriz(_,Filas),par(F,C),Elem):-
    nth0(F,Filas,Fila),
    nth0(C,Fila,Elem).
  
desglosarPalabras(Palabra, Acumulador, [Caracteres|Acumulador]):-
    atom_chars(Palabra,Caracteres).

desglosarLista(Lista,ListaDesglosada):-
  foldl(desglosarPalabras,Lista,[],ListaDesglosada).

sopaLetra(ListaAceptados,ListaRechazados,Aceptada,Rechazada):-
  desglosarLista(ListaAceptados,Aceptada),
  desglosarLista(ListaRechazados,Rechazada).
 

chequearPalabra(Alfabeto,H):-
  atom_chars(H,Palabra), subset(Palabra,Alfabeto).

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
  crearSopa(Tamano,Alfabeto,Sopa).
