# Set line number increment to 1 in zmakebas. Data pointer manipulations depends on this.

go sub @init
go sub @show_disclaimer
go sub @main_menu
stop

@init:
rem ******** Init *********
    bright 0: flash 0: border 0: paper 0: ink 7
    cls
    print "Loading";
rem ****** Setup UDG ******
    restore @udg
    read num
    for n = 1 to num
        read c$
        for i = 0 to 7
            read byte
            poke usr c$ + i, byte
        next i
        print ".";
    next n
    cls
return

@main_menu:
rem ******** Menu *********
    let pLink = 0
    let pBkLink = 0
    let cursor = 1
    let pItem = @items_main
    cls
    @menu_loop:
        restore pItem
        read t$, nItems
        print at 0, 0; t$
        print
        for i = 1 to nItems
            read m$, sublink
            if i = cursor then \
                let pLink = sublink :\
                print ink 4; i; ".>"; m$
            if i <> cursor then \
                print i; ". "; m$
        next i
        let pText = @text_help
        print at 16, 0
        go sub @show_text
        pause 0
        let key = code inkey$
        if key = 10 then \
            let cursor = cursor + 1
        if key = 11 then \
            let cursor = cursor - 1
        if cursor > nItems then \
            let cursor = nItems
        if cursor < 1 then \
            let cursor = 1
        if key = 13 and pLink > @menu_items then \
            let pBkLink = pItem :\
            let pItem = pLink :\
            let cursor = 1 :\
            cls
        if key = 13 and pLink < @menu_items then \
            go sub pLink :\
            cls
        if key = 8 and pBkLink > @menu_items then \
            let pItem = pBkLink :\
            let pBkLink = 0 :\
            let cursor = 1 :\
            cls
        if key = 48 then \
            return
    go to @menu_loop
return

@show_contact:
rem ****** Contact *******
  restore pContact
  for i = 0 to 3
    read s$
    print at contactPos + i,0; ink 7; paper 0; "     "; s$
  next i
  go sub @show_qr
return

@show_qr:
rem ****** QR code *******
  let third = int (contactPos / 8)
  let row = (contactPos - third * 8)
  let base = 16384 + third * 2048 + row * 32
  for y=0 to 3
    let pos = base + y * 32
    for l = 0 to 7
        for x=0 to 3
            read byte
            poke pos, byte
            let pos = pos + 1
        next x
        let pos = pos + 252
    next l
  next y
return

@prescroll:
rem ****** Prescroll ******
    print at 21,0;
    for i = 1 to 4
        POKE 23692,255
        print ""
    next i
return

@wait:
rem ******** Wait *********
    print ""
    print at 21,0; ink 4; "Press any key...                "
    pause 0
    print at 21,0; ink 7; "                                "
return

@show_text:
rem ****** Show text ******
    restore pText
    read lines
    for i = 1 to lines
        read l$
        POKE 23692,255
        print l$
    next i
return

@show_article:
rem ***** Show article *****
    cls
    restore pArticle
    read i$
    load i$ screen$
    pause 20 * 5
    let key = code inkey$
    if key = 8 then return;
    go sub @prescroll
    read pages
    for p = 1 to pages
        restore pArticle + p
        read pText
        go sub @show_text
        go sub @wait
        let key = code inkey$
        if key = 8 then return;
    next p
return

@show_disclaimer:
rem *** Show disclaimer ***
    cls
    let pText = @text_hello
    go sub @show_text
    plot 2, 105: draw 84, 4
    let contactPos = 10
    let pContact = @contact_repo
    go sub @show_contact
    let contactPos = 16
    let pContact = @contact_jsspeccy
    go sub @show_contact
    go sub @wait
return

@show_contacts:
rem **** Show contacts ****
    cls
    print ink 4; "My contacts"
    let contactPos = 4
    let pContact = @contact_email
    go sub @show_contact
    let contactPos = 10
    let pContact = @contact_github
    go sub @show_contact
    let contactPos = 16
    let pContact = @contact_vk
    go sub @show_contact
    go sub @wait
return

@show_about:
rem ****** Show about *****
    let pArticle = @article_about
    go sub @show_article
return

rem **** Show projects ****
@show_proj1:
    let pArticle = @article_proj1
    go sub @show_article
return
@show_proj2:
    let pArticle = @article_proj2
    go sub @show_article
return
@show_proj3:
    let pArticle = @article_proj3
    go sub @show_article
return

@menu_items:
rem ****** Menu data ******

@items_main:
data "Hi! Need some information?", 3
data "Who is Anhot?",            @show_about
data "Why am I here?",           @items_projects
data "Anhot's contacts",         @show_contacts

@items_projects:
data "Notable projects", 3
data "Vending machines (since 2017)", @show_proj1
data "Led equipment    (since 2013)", @show_proj2
data "Web development  (since 2012)", @show_proj3


rem **** Contacts data ****

@contact_repo:
data \
    "Beautifull origin of this page",\
    "available at",\
    "https://github.com",\
    "   /shadowlamer/mycyberpunk",\
    255,255,255,255,255,255,255,255,255,255,255,255,240,22,76,7,247,217,213,247,244,93,13,23,\
    244,95,21,23,244,90,181,23,247,221,117,247,240,21,84,7,255,244,143,255,242,88,213,247,247,\
    99,126,15,249,68,130,183,248,184,108,135,247,138,20,247,244,51,203,111,243,94,9,7,246,246,\
    236,151,246,73,208,79,255,242,55,79,240,30,245,119,247,223,71,103,244,81,0,103,244,81,197,\
    231,244,93,67,7,247,211,222,71,240,21,147,183,255,255,255,255,255,255,255,255,255,255,255,\
    255,255,255,255,255

@contact_jsspeccy:
data \
    "Source of emulator",\
    "available at",\
    "https://github.com",\
    "          /gasman/jsspeccy2",\
    255,255,255,255,255,255,255,255,255,255,255,255,240,27,28,7,247,214,45,247,244,80,93,23,244,\
    88,237,23,244,87,165,23,247,210,173,247,240,21,84,7,255,243,119,255,242,205,132,79,243,100,\
    161,247,244,65,247,231,245,111,147,127,247,87,65,167,253,164,52,151,246,215,92,87,251,107,\
    19,111,240,156,128,31,255,247,199,55,240,17,165,39,247,216,183,31,244,94,80,55,244,86,58,31,\
    244,92,22,87,247,214,33,191,240,22,198,231,255,255,255,255,255,255,255,255,255,255,255,255,\
    255,255,255,255

@contact_email:
data \
    "My email: anhot\@anhot.ru",\
    "",\
    "",\
    "",\
    255,255,255,255,255,255,255,255,255,255,255,255,240,29,52,7,247,213,237,247,244,95,117,23,\
    244,81,29,23,244,91,181,23,247,210,5,247,240,21,84,7,255,248,207,255,240,66,138,175,\
    245,237,86,159,246,149,204,103,253,55,104,103,251,1,41,23,242,191,167,223,245,8,10,39,\
    244,246,230,103,245,78,128,79,255,247,87,127,240,23,181,39,247,223,119,111,244,87,0,7,\
    244,83,209,71,244,80,87,215,247,212,199,55,240,20,125,71,255,255,255,255,255,255,255,255,\
    255,255,255,255,255,255,255,255

@contact_github:
data \
    "My GitHub profile:         ",\
    "https://github.com         ",\
    "               /anhotka",\
    "",\
    255,255,255,255,255,255,255,255,255,255,255,255,240,27,100,7,247,214,13,247,244,80,125,23,\
    244,88,205,23,244,87,165,23,247,210,205,247,240,21,84,7,255,243,119,255,242,205,196,79,\
    241,116,129,247,242,193,183,231,240,183,179,127,249,207,65,167,249,60,52,151,245,197,92,87,\
    249,37,19,111,242,136,128,31,255,247,199,55,240,21,165,39,247,220,183,31,244,94,80,55,\
    244,86,58,31,244,94,22,87,247,212,33,191,240,22,198,231,255,255,255,255,255,255,255,255,\
    255,255,255,255,255,255,255,255

@contact_vk:
data \
    "My VK profile:         ",\
    "https://vk.com         ",\
    "               /anhot",\
    "",\
    255,255,255,255,255,255,255,255,255,255,255,255,240,29,140,7,247,209,229,247,244,87,237,23,\
    244,91,93,23,244,81,69,23,247,213,101,247,240,21,84,7,255,244,199,255,242,206,20,79,\
    244,234,17,247,252,86,54,231,246,120,17,127,240,132,196,167,250,38,176,151,246,16,158,87,\
    250,234,225,111,241,67,32,31,255,241,7,55,240,20,69,39,247,217,87,15,244,95,240,55,\
    244,84,214,31,244,91,230,87,247,213,199,191,240,19,98,231,255,255,255,255,255,255,255,255,\
    255,255,255,255,255,255,255,255


rem ******** Texts ********

@text_hello:
data 9
data "This page is written in pure"
data "Sinclair BASIC and run in a"
data "living ZX Spectrum emulator."
data "You can press ""0"" or \s on"
data "virtual keypad to see source."
data "However modern technologies such"
data "as JS or Docker is used for its"
data "work. My brother have made it"
data "and I think it is amazing!"

@text_about1:
data 20
data "Hello there!"
data "My name is Oksana Chereneva and"
data "I am not sure what to tell you"
data "about myself..."
data "So let it be random facts!"
data "I'm a software tester."
data "I'm Russian. I can speak English"
data "and Korean (Korean - badly)."
data "I am a qualified philosopher"
data "(yes I know how it sounds)."
data "My favourite books are:"
data "1. Dan Simmons's Hyperion,"
data "2. The Master and Margarita"
data "by Mikhail Bulgakov,"
data "3. U.Eсo's Foucault's Pendulum."
data "If you would like to contact me,"
data "try SNS and messengers first"
data "or just send me a good old email."
data "Anyway thanks for visiting me."
data "Have a nice day, month and life!"


@text_proj1_1:
data 20
data "One small but proud vending"
data "machine manufacturer company"
data "asked to develop electronics"
data "and software for their machines."
data "I designed it, made prototypes,"
data "and helped launch production."
data "The equipment allows you to sell"
data "for cash and bank transfer,"
data "accepts contactless cards and"
data "allows you to connect terminals"
data "of two famous banks."
data "There is a remote monitoring."
data "Users can manage their devices"
data "through personal account."
data "Today, there are several"
data "thousand devices connected to"
data "the network, hundreds of users,"
data "dozens of new connections per"
data "month. One person manages"
data "technical support."

@text_proj2_1:
data 20
data "By request of representatives"
data "of the local show business, I"
data "developed a series of devices"
data "for LED equipment controlling."
data "The controllers are mainly "
data "oriented to use in LED suits"
data "and can work both with"
data "individual LEDs, LED stripes and"
data "matrices of various addressable"
data "LEDs. An important task in the"
data "development of such controllers"
data "is synchronization with music."
data "Devices have evolved"
data "sequentially from using DTMF"
data "sequences built into music to"
data "support MIDI and ArtNet"
data "protocols over WiFi."
data "Also, several controller models"
data "were developed for LED props,"
data "poi, luminous orbs, etc."

@text_proj3_1:
data 20
data "Managed to work as a hired"
data "full-stack developer in several"
data "projects. "
data "Used on the back-end:"
data "  Java, Spring, Spring Boot"
data "On the front-end"
data "  GWT, Flex, pure JavaScript,"
data "  AngularJS/Angular2"
data "For persistent storage:"
data "  JDBC, JPA, Hibernate, various"
data "  RDBs, Mongo, Elasticsearch"
data "Gained experience in teamwork,"
data "daily visits to the office, "
data "using collaboration tools."
data "Realized the value of testers"
data "and project managers."
data "I apply the acquired knowledge"
data "and experience when I need to"
data "develop a web service. This page"
data "for example."

@text_help:
data 5
data "Menu controls:"
data ""
data "\u/\d, Up/Down - select item,"
data "\r,   Enter   - choose item,"
data "\l,   Left    - return"

rem ****** Articles *******

@article_about:
rem data "photo", 3
data @text_about1
data @text_about2
data @text_about3

@article_proj1:
data "machine", 1
data @text_proj1_1

@article_proj2:
data "led", 1
data @text_proj2_1

@article_proj3:
data "java", 1
data @text_proj3_1

rem ****** UDG data *******

@udg:
data 5
# Stop button
data "S",60,66,129,153,153,129,66,60
# Up arrow
data "U",0,16,56,84,16,16,16,0
# Down arrow
data "D",0,8,8,8,42,28,8,0
# Left arrow
data "L",0,0,18,54,126,54,18,0
# Right arrow
data "R",0,0,72,108,126,108,72,0
