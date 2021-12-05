% De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se conoce el nombre y la cantidad de minutos de duración.

% a) Generar la base de conocimientos inicial

% cantante(Nombre,cancion(Cancion,Duracion)).
cantante(megurineLuka,cancion(nightFever,4)).
cantante(megurineLuka,cancion(foreverYoung,5)).

cantante(hatsuneMiku,cancion(tellYourWorld,5)).

cantante(gumi,cancion(foreverYoung,4)).
cantante(gumi,cancion(tellYourWorld,5)).

cantante(seeU,cancion(novemberRain,6)).
cantante(seeU,cancion(nightFever,4)).

cantante(flojo,cancion(wasaa,2)).

cantante(flojoYMuchosTemas,cancion(wasaa,2)).
cantante(flojoYMuchosTemas,cancion(wasup,3)).

% 1. Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.

esNovedoso(Cantante):-
    cantante(Cantante,_),
    sabeAlMenosDosCanciones(Cantante),
    tiempoTotalMenorA15(Cantante).

sabeAlMenosDosCanciones(Cantante):-
    cantante(Cantante,cancion(Cancion,_)),
    cantante(Cantante,cancion(OtraCancion,_)),
    Cancion \= OtraCancion.

tiempoTotalMenorA15(Cantante):-
    findall(Duracion, cantante(Cantante,cancion(_,Duracion)), ListaDeDuraciones),
    sumlist(ListaDeDuraciones, DuracionTotal),
    DuracionTotal < 15.
    
% 2. Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2.

esAcelerado(Cantante):-
    cantante(Cantante,_),
    not(dura4OMas(Cantante)).

dura4OMas(Cantante):-
    cantante(Cantante,cancion(_,Duracion)),
    not(Duracion >= 4).

