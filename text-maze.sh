#!/bin/bash
WHEREAMI="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd && echo)"
cd $WHEREAMI
file=sample.txt
LOOKUP=$WHEREAMI/lookup.sh
TIMG=$WHEREAMI/T-IMG.sh
CANTMOVE="cannot move in that direction."
FINISH="congradulations, you won."
START="Welcome to text-maze."
name="$(sed '1q;d' $file)"
MODID="$(sed '2q;d' $file)"
MODTABLE=$(cat $MODID)
sizey=$(sed '3q;d' $file)
sizex=$(sed '4q;d' $file)
starty=$(sed '5q;d' $file)
startx=$(sed '6q;d' $file)
endy=$(sed '7q;d' $file)
endx=$(sed '8q;d' $file)
Playy=$starty
Playx=$startx
echo "$START
$name"
until [[ "$end" = "1" || "$entry" = "quit" ]]; do
  echo -n "maze view
1" > COMPOSITE.TIMG
  yc=1
  for y in $MODTABLE
  do
    xc=1
    listC=$(echo $y | grep -o .)
    echo "" >> COMPOSITE.TIMG
    for x in $listC
    do
      if [[ "${xc},${yc}" = "${Playx},${Playy}" || "${xc},${yc}" = "${endx},${endy}" ]]; then
        if [ "${xc},${yc}" = "${Playx},${Playy}" ]; then
          echo -n "C" >> COMPOSITE.TIMG
        else
          if [ "${xc},${yc}" = "${endx},${endy}" ]; then
            echo -n "G" >> COMPOSITE.TIMG
          fi
        fi
      else
        echo -n "$x" >> COMPOSITE.TIMG
      fi
      CNT2=$(echo "$xc+1" | bc)
      xc=$CNT2
    done
    CNT1=$(echo "$yc+1" | bc)
    yc=$CNT1
  done
  echo
  echo "
!" >> COMPOSITE.TIMG
  $TIMG "$WHEREAMI/COMPOSITE.TIMG"
  entry=nullvalue
  until [[ "$entry" = "up" || "$entry" = "down" ||  "$entry" = "left" || "$entry" = "right" || "$entry" = "quit" ]]; do
    echo "valid options: up, down, left, right, quit"
    read entry
  done
  tput clear
  if [ "$entry" = "up" ]; then
    if [ "$(echo "($Playy-1)<1" | bc)" = "1" ]; then
      echo "$CANTMOVE"
    else
      BIND1=$(echo "$Playy-1" | bc)
      echo "$Playx" > lookup.txt
      echo "$BIND1" >> lookup.txt
      echo "$MODID" >> lookup.txt
      bidle=$($LOOKUP)
      #echo $bidle
      if [ "$($LOOKUP "$Playx\$BIND1\WHEREAMI/$MODID")" = "1" ]; then
        echo "$CANTMOVE"
      else
        upcnt=$(echo "$Playy-1" | bc)
        Playy=$upcnt
      fi
    fi
  fi
  if [ "$entry" = "down" ]; then
    if [ "$(echo "($Playy+1)>$sizey" | bc)" = "1" ]; then
      echo "$CANTMOVE"
    else
      BIND2=$(echo "$Playy+1" | bc)
      echo "$Playx" > lookup.txt
      echo "$BIND2" >> lookup.txt
      echo "$MODID" >> lookup.txt
      bidle=$($LOOKUP)
      #echo $bidle
      if [ "$(${LOOKUP} "$Playx\$BIND2\$MODID")" = "1" ]; then
        echo "$CANTMOVE"
      else
        downcnt=$(echo "$Playy+1" | bc)
        Playy=$downcnt
      fi
    fi
  fi
  if [ "$entry" = "left" ]; then
    if [ "$(echo "($Playx-1)<1" | bc)" = "1" ]; then
      echo "$CANTMOVE"
    else
      BIND3=$(echo "$Playx-1" | bc)
      echo "$BIND3" > lookup.txt
      echo "$Playy" >> lookup.txt
      echo "$MODID" >> lookup.txt
      #$LOOKUP
      if [ "$(${LOOKUP} $Playy\$BIND3\$WHEREAMI/$MODID)" = "1" ]; then
        echo "$CANTMOVE"
      else
        leftcnt=$(echo "$Playx-1" | bc)
        Playx=$leftcnt
      fi
    fi
  fi
  if [ "$entry" = "right" ]; then
    if [ "$(echo "($Playx+1)>$sizex" | bc)" = "1" ]; then
      echo "$CANTMOVE"
    else
      BIND4=$(echo "$Playx+1" | bc)
      echo "$BIND4" > lookup.txt
      echo "$Playy" >> lookup.txt
      echo "$MODID" >> lookup.txt
      #$LOOKUP
      if [ "$(${LOOKUP} $Playy\$BIND3\$WHEREAMI/$MODID)" = "1" ]; then
        echo "$CANTMOVE"
      else
        rightcnt=$(echo "$Playx+1" | bc)
        Playx=$rightcnt
      fi
    fi
  fi
  if [ "${Playx},${Playy}" = "${endx},${endy}" ]; then
    echo "YOU WIN!!!"
    end=1
  fi
done
echo "press enter to exit"
read nullvaliue
