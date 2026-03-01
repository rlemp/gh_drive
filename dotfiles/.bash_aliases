#    ============================
#    LISTER tous les alias
#                                              compgen -a
#   ou                                       alias -p | cut -d= -f1 | cut -d' ' -f2                                     (  cut -d=  delimiter=   -f1 premier champ  |   cut -d' ' -f2  deuxieme champ )
#   pour lister tous les alias:    alias
#    
#   (voir: https://www.baeldung.com/linux/list-commands-aliases)
#    ============================
alias fd="fdfind "
alias bashaliases="fd -H '^.bash.*ses$' -x gedit"
alias scripts="cd ~/scripts/"
alias bureau="cd ~/Bureau"
#alias nettoyer="find . -maxdepth 2 -type f \( -iname "squote*~" -o -name '.bash_history-*.tmp' \) -ok rm {} \; "   # nettoyer history*tmp & squote*~ 
#alias bleach="bleachbit -c --preset 2>/dev/null && find . -maxdepth 2 -type f \( -iname "squote*~" -o -name '.bash_history-*.tmp' \) -ok rm {} \;  gpaste-client empty " # nettoyer tout
#    =================ittybitty===========
#  https://github.com/arfct/itty-bitty/wiki

alias ittybitty='min 'https://itty.bitty.site/edit'  && exit'
alias ittycode='cat itty.txt | lzma -9 | base64 -w0 | xargs -0 printf "https://itty.bitty.site/#/%s\n"'

# decode in terminal:

# alias ittydecode="echo -n "$URL" | sed -E 's/^.*#[^\/]*\/\??//g' | base64 -d | lzma -d"  #probleme

# echo -n "[URL]" | sed -E 's/^.*#[^\/]*\/\??//g' | base64 -d | lzma -d
# echo -n "https://itty.bitty.site/#/XQAAAAT//////////wA0GUnujekXiTozYAX3z2T/+3ggAA==" | sed -E 's/^.*#[^\/]*\/\??//g' | base64 -d | lzma -d

#    ==================photos==========
alias phos='firefox https://photos.google.com/u/1/ && exit'
alias phoa='firefox https://photos.google.com/u/2/ && exit'
alias phom='firefox https://photos.google.com/u/3/ && exit'
alias phop='firefox  https://photos.google.com/ && exit'
alias play='chromium https://creatorscloud.sony.net/app/fr/library/?folder_id=1992021463542-f-711a5ac8   && exit'

#  coloriser restorer
alias baseten="firefox https://app.baseten.co/apps/QPp4nPE/operator_views/RqgOnqV & firefox https://imageamigo.com/restore/ & firefox https://palette.fm/  & firefox https://www3.lunapic.com/editor/ https://waifu2x.io/  & firefox https://hotpot.ai/restore-picture  & firefox https://www.upscale.media/fr/upload && exit"
alias hotpot="firefox https://hotpot.ai/restore-picture && exit"           # restaurer
alias lunapic="firefox https://www3.lunapic.com/editor/ && exit"      # traiter image coloriser (adjust/colorize old photo)
alias colorize="firefox https://palette.fm/ https://www.img2go.com/colorize-image https://www.phot.ai/user-activity?tool=ai-photo-colorizer && exit"       # coloriser

#   =================================
alias trello='firefox https://trello.com/b/ZaxXQz1Q/recettes && exit'
alias feed=' firefox https://feedly.com/i/collection/content/user/f5bb97f3-820a-4480-939a-09d7ca3f51c1/category/global.all && exit'

#  ===================================
alias navionics='firefox https://webapp.navionics.com/#boating@10&key=qkl%7CEahdyD  &&  exit'
# alias maps='firefox https://www.scribblemaps.com/create/#id=mY5oXwKJmf && exit'
# alias maps='firefox https://www.scribblemaps.com/maps/view/k90b/3gfrMP6kEn && exit'
# alias maps='firefox https://www.scribblemaps.com/create/#/id=3gfrMP6kEn&lat=38.25767736&lng=15.04265697&z=11&t=hybrid && exit'
# alias maps='firefox  https://www.scribblemaps.com/create/#id=pluieideecopletecasting && exit'
# alias maps='firefox  https://www.scribblemaps.com/create/#id=pluieideecopletecasting1 && exit'
# alias maps='firefox  https://www.scribblemaps.com/create/#id=pluieideecopletecasting2 && exit'
# alias maps='firefox  https://www.scribblemaps.com/create/#id=pluieideecopletecasting3 && exit'
 alias maps='firefox  https://www.scribblemaps.com/create/#id=pluieideecopletecasting8 && exit'
 
#   =================================
alias scan='xsane'
alias simplescan="simple-scan"

#   =================================
alias pcloud='~/applications/pcloud'
alias corbeillepcloud='firefox https://my.pcloud.com/#page=trash'

#   =================================
alias tv='firefox https://www.programmetv.ch  & epiphany  https://itty.bitty.site/#/?eF6FlUGu2yAQhq/CqpvqqQZsx1ajSE/qpqtKbS+ACU6cGuwCTtqcqzfoxZrXeHh2w9AsrBg+huGff/B23D39/W3fjbvtuGP8jWnc+H75rMp5svTKRqaLeVo09HGWZjxMR2KvUSD7k7oqZQVObgA1nRbTDwxkNXDWK3LcowEZZNkoIifbDZO7z2Rw+KYfBt0oe8BilNVMyuq/6UhhRP8WzYbnK072oosIT7NsidURYhWnTghQ80BaISkhnC0HGKG0Wg7w20C9HMgJZflyoCAEpJNHZTvFikiCRWBMI1Flw07GYMwmaOG8sITDq5rsYNTFoVpndCZbltKnCFSOMTxE4imrZSFUnsIKsHhbJDEoXPv7F74lVOYw9X2HYrDjcR9pZNgPQvVicx+a33WJramhxlpdrwNGBfcYe8KYYErj0Qw5CHIrO/HnOe3g3vHmTT1Mxj+urKB+Yy+M8grtTwbmslqSvZLDdFa3+wXDK9DVDtNBQUorhQLhY208n6EKkKMpS+TlKxj3NM1hQ9emQvFApXqDFlngOtNGKlxDA7tvP1PNWK6qOq/xFL1P789wq/rkYWow2NeWtl2vyauXfRv5ggQjeanTCdAMfOk1eomF69KfCz2YPWoXCsEuqBUYOHXb2N389/Pzh4+fvjyyoPylc46cxPWKBS3ZZsXevjrOdfilzMBmrRVGKqIn132f0GOV4fNunSVo+5YcdLLHlw5uUe1LHlFBD068ZBHboIro+U+EP6OG+vk=  && exit'

#   =================================
alias pt='firefox https://www.protectedtext.com/bMq56YZYas+?93898fd28560778019cdd62ed7ebb2ee  #  https://zen.unit.ms/   https://app.standardnotes.com/  && exit' 
alias ptrcl=' min https://www.protectedtext.com/professeurjoieperechat?a3188516fd03cdde6013ca553caa74f8  && exit '

#   =================================
alias not='micro ~/pCloudDrive/.note/note && exit'
alias noname='bureau ; micro noname && exit'
alias cheatsheet='bureau ; micro cheatsheet && exit'
alias send='firefox https://send-anywhere.com/  && exit'
alias saltify='firefox https://www.saltify.io/  && exit'

#  =====================================
alias bak='deja-dup'

#   =================================

alias carpostal='min https://www.postauto.ch/fr/horaire-et-reseau/horaire-et-achat-de-billets/horaire-resultat-de-la-recherche?from=Blignou+%28Ayent%29%2C+Corbarare&to=Sion%2C+Clinique&date=2023-06-05&type=departure&time=09%3A54&via=&transport-type=ice%2Ftgv%2Frj%3B+ec%2Fic%3B+ir%3B+re%2Fd%3B+s%2Fsn%2Fr&transport-type=bus&transport-type=tramway&transport-type=tramway&transport-type=boat&transport-type=cableway&transport-type=arz%2Fext&transport-type=cableway&transport-type=cableway&transport-type=tramway&connection-type=dc&connection-type=bft&connection-type=wbt&connection-type=wgt && exit'
alias radar='min https://meteo.search.ch/prognosis  && exit'

#   ==========================copie contenu fichier dans presse papier======
alias cpc="xclip -sel c < "

#   ==========================generer un pw avec hash md2============
alias md2='min https://codebeautify.org/md2-hash-generator?input=rosefalloirreveimmense+'
alias hachage=' md5sum  $1'    # hachage...enter...texte...ctrl D  >>resultat
#   =============================google==proton=====
alias gdrive='firefox https://drive.google.com/drive/u/0/my-drive && exit'
alias gmail='firefox https://mail.google.com/mail/u/0/#inbox && exit'
alias contacts='firefox https://contacts.google.com/ && exit'
alias agenda=" firefox  https://calendar.google.com/calendar/u/0/r/week?pli=1 && exit"
alias acces='firefox https://myaccount.google.com/permissions?hl=fr'
alias proton="firefox https://account.proton.me/mail"

#   ========================== copie dans souris========
#alias bit='echo declarationnatureplurielfaible | xclip  &&  exit '
alias bit='xclip<<<declarationnatureplurielfaible && exit'
#alias ros='echo rosefalloirreveimmense | xclip  &&  exit'
alias ros='xclip<<<rosefalloirreveimmense && exit'
#alias rcl='echo professeurjoieperechat | xclip  &&  exit'
alias rcl='xclip<<<professeurjoieperechat && exit'
alias crypt='echo possibilitelongueurlegerementpouce | xclip  &&  exit'
alias kde='echo clotureeviercoursbase | xclip  &&  exit'
alias nes='echo yFRq4vvK8I | xclip  &&  exit'
alias sun='echo 6gLvmE16v3kn | xclip && exit'
alias ali='echo puissantmercimoinstronc | xoclip && exit'  # ptfilsaaline
alias reserve='echo ecrancochonstyloperdu | xclip  &&  exit'
alias nouveau='xclip <<<curieneigefaireblanc   && exit'
alias gfournier='echo "policeconnaitrelongtempscroissance+" | xclip  &&  exit'
alias nb="echo aminouveauchansonceinture | xclip && exit"
alias sgp='supergenpass.sh $1'   # version modifiee |xclip pour memorisation pw
# alias sgp='ros && min https://chriszarate.github.io/supergenpass/mobile/ && exit'  # version web  url:  https://chriszarate.github.io/supergenpass/mobile/
# alias sgp= "waterfox '/home/lemp/scripts/sgp.html' "  #version js-html
alias heure='date +'%y%m%d_%H%M%S' | xclip -selection  clipboard &&  exit'    # pointer la date_heure dans le presse-papier
alias pos='echo orbitedevoirmangerchose | xclip  &&  exit'      #pw de l'utilisateur postgres
alias pwgen='firfox https://preshing.com/20110811/xkcd-password-generator/'  #password generator
alias fais='echo faismoirirefred | xclip  &&  exit '

#   ===================================exemple commandes rclone============
# rclone

alias localcrypt='echo professeurjoieperechat | rclone sync '/home/lemp/Bureau/dossier'     localcrypt:'

alias yanc='echo professeurjoieperechat | rclone sync '/home/lemp/Bureau/rclone' yandex:enclair'
alias yane='echo professeurjoieperechat |  rclone sync '/home/lemp/Dropbox' yandexcrypt:'
alias yani='echo professeurjoieperechat | rclone sync  yandexcrypt:  '/home/lemp/Bureau/yandexDecrypt''
alias yanl='echo professeurjoieperechat | rclone ls yandexcrypt:'

alias pcloudc='echo professeurjoieperechat | rclone sync '/home/lemp/Bureau/rclone' pcloud:enclair'
alias pcloude='echo professeurjoieperechat | rclone sync --copy-links '/home/lemp/Bureau' pcloudcrypt:Bureau'
alias pcloudi='echo professeurjoieperechat | rclone sync pcloudcrypt:  '/home/lemp/Bureau/pcloudDecrypt' '
alias pcloudl='echo professeurjoieperechat | rclone ls pcloudcrypt:'

alias boxe="echo professeurjoieperechat | rclone copy  '/home/lemp/Dropbox/finances/energies/energies consommation .ods'  box:energies"
alias sauvegarde="echo professeurjoieperechat | rclone sync '/home/lemp/MEGA/images/mpic'  local:/home/lemp/sauvegarde/images/mpic"
#  =======================================monter cloud dans dossier=============
# 
alias monterphop='bureau ; echo professeurjoieperechat | rclone mount phop: dossier'
# alias monterphop='bureau ; echo professeurjoieperechat | rclone mount phop: dossier --vfs-cache-mode writes'
# alias monterphop='bureau ; echo professeurjoieperechat | rclone mount phop:album/ciba dossier --vfs-cache-mode writes'
#                           cp -r '/home/lemp/Bureau/dossier/album/hippocampe 61-62'    '/home/lemp/Bureau' 

alias monteryandexcrypt='bureau ; echo professeurjoieperechat | rclone mount yandexcrypt: dossier'

alias monterbox='bureau ; echo professeurjoieperechat | rclone mount box: dossier'
alias monterboxcrypt='bureau ; echo professeurjoieperechat | rclone mount boxcrypt: dossier'

alias monterpcloud='bureau ; echo professeurjoieperechat | rclone mount pcloud: dossier'
alias monterpcloudcrypt='bureau ; echo professeurjoieperechat | rclone mount pcloudcrypt: dossier'

alias montergdrivechristine='bureau ; echo professeurjoieperechat | rclone mount "gdrive christine": dossier'
alias montergdrivechristinecrypt='bureau ; echo professeurjoieperechat | rclone mount "gdrive christinecrypt":  dossier'

alias monterlocalcrypt='bureau ; echo professeurjoieperechat | rclone mount localcrypt: dossier'

alias demonter="fusermount -u /home/lemp/Bureau/dossier"
#   ===========================sauvegarde sur cle USB===========
# alias synchro='pcloude;yane;boxe;albums;sauvegarde;256G'  # voir script synchro

#   ======================================
alias rclonebrowser='rclone-browser & rcl'

#   ======================================
alias chrome='google-chrome-stable  --disable-extensions  '

#   ======================================
alias meta="logmd  &&  micro '/home/lemp/Bureau/Lien vers kilikina 91c.txt'  && micro '/home/lemp/Bureau/logmd.md'  && exit"    #clipper/souris les meta donnees ouvrir logmd.md et Lien vers kilikina 91c.txt
alias meta2=" cd /home/lemp/Bureau/meta2/ && ./meta_v02  && exit"   # creer un fichier MD des metadata des images d'un dossier >>resultat

alias copier="exiftool -TagsFromFile $1 $2 "   # copier le metadata d'une image a l'autre
alias supprimer='exiftool -ImageHistory= $1'   #suprimmer l'historique fotoxx d'une image    
alias supprimertout='exiftool -all= $1'   #suprimmer le meta d'une image    
#   ============================================
				#alias  obs='/home/lemp/applications/Obsidian-1.4.13.AppImage && exit'
alias obs='snap run obsidian --force-device-scale-factor=1.5'

# alias trash='ls -lA '/home/lemp/snap/obsidian/current/.local/share/Trash/files''
alias corbeilleobs='xdg-open ~/snap/obsidian/current/.local/share/Trash/files'

# ======================================
# alias killfirefox='no=$(pgrep firefox) ; kill $no && exit'
# alias killfirefox='killall firefox'

             # alias fkillall='ps -e -o pid,comm | fzf --tac --no-sort | awk '{print $2}' | xargs -r -r killall  # fuzzy killall'

alias killfirefox='pkill firefox'
# alias killfotoxx='no=$(pgrep fotoxx) ; kill $no && exit'
# alias killfotoxx='killall fotoxx'
alias killfotoxx='pkill fotoxx'

 alias killbash="kill -9 \$(pgrep bash | grep -v ^\$\$\$) 2>/dev/null"  # tuer tous les bash sauf l'actuel
 alias killbash1="killall -9 -o 1m bash" #tuer tous les bash +vieux que 2minutes
 #alias killbash="pkill -9 -n bash"  #tuer le bash le plus recent
 alias fermerterminal="pkill  gnome-terminal"  # fermer terminaux
  # alias cleanterms='NEWEST_BASH_PID=$(pgrep -n bash); PIDS_TO_KILL=$(pgrep bash | grep -v "$NEWEST_BASH_PID"); [ -n "$PIDS_TO_KILL" ] && kill -9 $PIDS_TO_KILL'

# +++++++++++++++++++++++++++++++
alias wtf='wtfutil'
# ++++++++++++++++++++++++++++++++

# ======================================
alias mxlinux="firefox https://www.onworks.net/runos/create-os.html"

# ==============================ai=========
# alias ai="firefox   https://huggingface.co/chat/conversation/644d4aa99afb2d758998ec4b  https://www.you-tldr.com/ https://www.chatpdf.com/ https://www.phind.com/search?cache=0eeabbd6-e7aa-4ad4-90df-7ff9685fa5cd   && exit"
alias phind='firefox https://www.phind.com/search?cache=0eeabbd6-e7aa-4ad4-90df-7ff9685fa5cd&init=true  &&  exit'
alias you='min  https://www.you.com'
# alias gemini='firefox https://gemini.google.com/app && exit'

alias godmode='falkon https://godmode.space/ '
alias copilot='falkon --private-browsing  https://copilot.microsoft.com/'
alias chatpdf='min https://www.chatpdf.com/'
alias gab='falkon https://gab.ai/c/65e744e03c0930cbfc78cb94'
alias claude='firefox https://www.anthropic.com/news/claude-2'
alias chatgpt="firefox https://chat.openai.com/auth/login"
alias genius='falkon https://essaygenius.ai/'
alias perplexity='waterfox --private  https://www.perplexity.ai/  && exit'
alias ddg='firefox https://duck.ai'
alias deepseek="firefox https://chat.deepseek.com/"

# ============================================
alias shadowdrive="/home/lemp/applications/ShadowDrive-Linux64.AppImage"
alias yallo='firefox https://yallo.tv/fr'
alias ubs="chromium https://ebanking-ch4.ubs.com/workbench/WorkbenchOpenAction.do?login&isiwebuserid=36135166&tab=CR"


# ========================= tester un script bash / questions==============
alias bashtest="epiphany https://www.shellcheck.net/"    #  Paste a script to try it out:
 # alias gdb="firefox https://www.onlinegdb.com/"
alias stack="firefox https://stackoverflow.com/search?q=find+xarg+exec&s=99dee3c8-fa0a-436c-9cb9-7237b31e5f4f"


# ============================================
alias digitalstamp="firefox https://webstamp.post.ch/#/mobilestamp/checkout"

alias nettete=" bureau; mogrify -type grayscale -sigmoidal-contrast 8,60% -enhance -normalize -unsharp 10,1 $1"

alias web='epiphany'
alias recettes="firefox https://getpocket.com/fr/saves/tags/recette"   # recettes sur pocket
alias pocket="firefox https://getpocket.com/fr/saves"     # pocket
alias enregistres="firefox https://www.google.com/interests/saved?authuser=0"   # 'pocket-google'
alias raindrop="firefox https://app.raindrop.io/my/0/%22%23linux%20terminal%22"  # raindrop 'pocket'

alias mezzo="min https://www.mezzo.tv/fr/programme"
alias prevision="firefox https://www.accuweather.com/fr/ch/sion/315550/january-weather/315550?year=2024  https://meteofrance.com/ https://weather.com/weather/monthly/l/ccb253ebcdf3fc9bdd3745f31feef3eca9fdf2625c42ef28407b304df9137204"
alias md2pdf='firefox https://md2pdf.netlify.app/'
alias md2html='firefox https://markdowntohtml.com/'
alias registrecommerce='firefox https://www.zefix.ch/fr/search/entity/welcome'
alias calculette="gnome-calculator"
alias calc='python3'
alias py="python3"
alias horloge="gnome-clocks"
alias ipwebcam="chromium 192.168.1.43:6677"


alias routeur="firefox 192.168.1.1"
alias extension='extension-manager'    # gnome extensions manager

# ===== recherche==========================================
# alias trouve2="trouve() { find . -type f -iname "*$1*" -or -type d -iname "*$1*"; }"
# alias trouve='find . -type f -iname "*$1*" -or -type d -iname "*$1*"'

# alias fz='xdg-open "$(fd --exclude 'MEGA' --exclude 'ShadowDrive' --exclude 'sauvegarde'  --exclude 'pCloudDrive' | fzf )"'   # affiche tout sauf mega etc
# alias fz='find ~/ -type f,d | fzf --bind "enter:execute(xdg-open "{}")" --preview "echo {}"'  # affiche affiche tout et ouvre le choix (--preview='less {}')
# alias fz='xdg-open "$(find | fzf -m)" '
#alias fz='xdg-open "$(find | fzf )"'
#alias fz='find  | fzf -m | while IFS= read -r file; do xdg-open "$file"; done'  # choix multiple posssible
# alias fz='find  | fzf -m --color=16 | while IFS= read -r file; do xdg-open "$file"; done'  # choix multiple posssible
#alias fz='find  | fzf -m --color='fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81,info:144,prompt:161,spinner:135,pointer:135,marker:118' | while IFS= read -r file; do xdg-open "$file"; done'  # choix multiple posssible, molokai

		# rajouter la fonction fz dans bashrc (a cause du query)
		#fz() {
		#    xdg-open "$(find . -type f | fzf -m --query "$1")"
		#}
                    
# alias cmd='cat ~/Bureau/liste_commandes | fzf -m | xargs -d "\n" -I {} bash -c "{}"'  # affiche la liste de commandes de 'cmd' et l'execute
# alias cmd='eval "$(cat ~/Bureau/liste_commandes | fzf -m)" '
alias cmd_='echo "commandes ^X^M (hledger ^X^H)"'
# alias 2fa=' eval "$(gpg -d '/home/lemp/Sync/secret_commandes.gpg' | fzf)" '
alias 2fa='eval $(unbuffer gpg -d /home/lemp/Sync/secret_commandes.gpg | tail -n +3 | fzf --height=80% --border --layout=reverse-list --prompt="choisir un compte: " --no-info)'

alias copy='cp "$(fzf)" "$(find -type d | fzf)"'   # copie un fichier vers un dossier
alias dif='fzf -m | xargs -n 2 diff '      # choix avec fzf et comparer 2 fichiers

# ===================================================
alias xdg="xdg-open"   # plus simplement open
alias vis="eog"       #visionneur images
alias czk="czkawka_gui"
alias nix="nixnote2"

# =============navigateurs======================================
alias wat="waterfox --private"
alias mid="midori"
alias pal="palemoon"
alias tangram="flatpak run re.sonny.Tangram"
alias zen_browser="/home/lemp/applications/zen-x86_64.AppImage"   # "flatpak run io.github.zen_browser.zen"
alias thorium="thorium-browser"
alias ly="lynx -accept_all_cookies -cookie_file=/dev/null"

# ===================================================
alias btc=" elinks -dump https://www.coingecko.com/fr/pi%C3%A8ces/bitcoin/chf | grep  'Le prix de la conversion de 1 Bitcoin (BTC) en CHF est Fr.' | head -n 1   | sed 's/Le prix de la conversion de 1 Bitcoin (BTC) en CHF est Fr.//' | sed 's/ //g' | sed 's/,/./'  | sed 's/\..*//' | xclip -selection  clipboard "   # ou elinks ...

alias meteoblue="links2 -g https://www.meteoblue.com/fr/meteo/semaine/botyre-%28ayent%29_suisse_11048475 ; links2 -g https://www.meteoblue.com/fr/meteo/14-jours/botyre-%28ayent%29_suisse_11048475"

# ===================================================
alias reboot='systemctl reboot --firmware-setup'
alias update="sudo apt-get update && sudo apt-get upgrade"

# ============info tv=======================================
alias mastodon="epiphany https://botsin.space/@RadioTeleSuisse"


alias cal='open ~/calendar.txt'

alias cpq="copyq & copyq show"
alias cpqx="copyq exit"

alias mt='marktext'
alias gte='gnome-text-editor'

# alias chrono='stty -echo; echo "ctrl+C pour arreter"; command time --quiet -f %E cat ; stty echo'
alias chrono='echo "ctrl+D stop chrono";command time -f "\t\t%E    min:sec" --quiet cat'

alias pcloud='/home/lemp/applications/pCloud.AppImage & exit'

alias ugedit='ug -%% -jwQ --view=micro --filter= text --hidden  -1,3'
# ============================

# Activer Tor et configurer Firefox
alias tor-on='sudo systemctl start tor && echo "user_pref(\"network.proxy.type\", 1); user_pref(\"network.proxy.socks\", \"127.0.0.1\"); user_pref(\"network.proxy.socks_port\", 9050); user_pref(\"network.proxy.socks_remote_dns\", true);" > /home/lemp/snap/firefox/common/.mozilla/firefox/fisb23gc.default/user.js && echo "Tor ACTIVE - Redémarrez Firefox"'

# Désactiver Tor et remettre Firefox en direct
alias tor-off='sudo systemctl stop tor && echo "user_pref(\"network.proxy.type\", 0);" > /home/lemp/snap/firefox/common/.mozilla/firefox/fisb23gc.default/user.js && echo "Tor DESACTIVE - Redémarrez Firefox"'

# controle etat tor et firefox
alias tor-status='torsocks curl https://check.torproject.org | grep -i "congratulations"'

# controle fichier firefox/parametres/reseau
alias tor-check='micro /home/lemp/snap/firefox/common/.mozilla/firefox/fisb23gc.default/user.js'

# checking tor via firfox
alias tor-check-firefox='firefox https://check.torproject.org/'

# ==========================
