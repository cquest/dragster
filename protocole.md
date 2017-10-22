# Protocole Dragster

Protocole de multiplexage Dragster utilisé entre le Macintosh et les modems ou autres interfaces matérielles (Wit Boost, Dragster X25).
(Reverse engineering depuis le code source Pascal de Dragster)

Liaison série:
- 19200 bps
- 8 bits
- 1 bit de stop
- pas de parité

Chaque voie (1 par modem/wit boost, plusieurs sur Dragster X25) est unique, de 0 à 63.

Paquets sortants (du Macintosh):

0: longueur totale (n)
1: $C0 + N° de voie
2: commande
.... données
n: $80

Commandes:

0 : contrôle modem maître (protection hardware)
2 : contrôle modem maître (protection hardware)

! : envoi de données sur une voie

? : statut de la voie / état de la saisie
 vide = voie connectée, pas de saisie
 1: F = déconnecté, C = connecté ?
 .... saisie en cours

Z : définition d'un zone de saisie
 3: $40 + n° de colonne
 4: $40 + n° de ligne
 5: $40 + longueur de zone DIV 16
 6: $40 + longueur de zone MOD 16
 7: $40 attributs de la zone
 8: $40 attributs de la zone
 9: $7F (echo normal) ou * (écho masqué)
 10: '.' ou 'X' (caractère de zone de saisie)

z : suppression de zone de saisie

U : saisie sans zone
 1: 'E'
 2: caractère d'écho ($7F = écho normal, * = echo masqué)

T : téléchargement de données
 1: 'S' envoi de l'écran par défaut, puis envois par '!' et fin avec 't'
 1-2: '00' à '99' messages

t : fin de téléchargement d'écran d'indisponibilité

P : paramètres
 1: 'N' = pas de vidage de buffer sur CLS
 2: 'N' = pas de beep sur les erreurs de saisie
 3-5: 'nnn' = nombre de secondes sans commandes avant affichage "Veuillez patienter"
 6-8: 'nnn' = nombre de secondes sans commandes avant affichage de l'écran d'indisponibilité

A : appel d'un numéro

R : retournement du modem

D : déconnexion
