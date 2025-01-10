# -*- coding: UTF-8 -*-
'''
update histoty
--3.22:
Yeah! The fisrt beta version is published!
--3.23:
1.add customize mode
2.add op mode
3.adjust the value of easy mode and impossible mode in order
to make the game more reasonable and defiant.
4.fix a bug which may make year input goes wrong
5.fix some descriptions' problems
6.fix some bugs which will make some value goes wrong.
--3.24:
1.remove op mode
2.add some easter eggs
3.simplize the code
--3.25
1.fix some stupid bugs
2.when player chooce to quit or suicide, they will be ask again to make sure
--3.26
1.simplize the code
2.now health will decrease 2 per month
--3.27
1.now the date and month will be counted correctly
2.a new warning for player when they have low food and health
3.a easter egg for Meriwether Lewis was add
--3.28
1.now the health will decrease randomly per month
2.bug fix: when player run out of food or health, a negative value will be showed.
Now when player run out of food or health, there will be no warning for food and health.
Player will receive game over hint immediately
3.now player will meet a random event that occurs randomly once a month
4.better loading (just for fun)
5.fix a bug that the random days of accident are not counted into total days correctly
--3.29:
1.now when player type mode choice incorrectly, they will be asked to type again,
instead fo beginning the game without correct value and erro
2.update the name input part to avoid some bug
--3.30:
1.now when the players type their choice wrong, an hint will be show to tell them that
they make mistake on spelling or they type something which is not an available choice
2.now this program can be run in python2 environment.
--4.2:
1.bug fix: the mode input can be nothing
--4.4:
1.bug fix: the year input can be nothing
2.now the date is shown more clearly
--4.6:
1.bug fix:in customize mode, the input for food and health may cause erro

future plan:
1.simplize the code
2.the players can choose the month and the date which they want to start
3.add background picture
4.add background music
5.improve the playing feeling
6.more hints for players
7.game can be played again after game over
8.the balance of value for each mode
9.more amazing modes will be added soon
10.tell a story?
11.more easter eggs
12.multiplayer mode
13.a shop for buging things?
14.email the data of game to author after player finish the game
This will help me to do the balance of value.
15.a function to check leap year will be added soon
16.chinese virson support?
'''

#import
import random
import time
#import smtplib send email import

#welcom player
print('ゲーム「オレゴントレイル」へようこそ！')

#asking name
player_name = input('あなたの名前は何ですか？:')
while len(player_name) >= 0:
  if len(player_name) > 1:
    print(str(player_name)+"? It is a good name.")
    break
  if len(player_name) == 1:
    player_name_choice = input(str(player_name)+"? Are you kidding me? Only one letter?(y/n):")
    if player_name_choice == "y" or player_name_choice == "Y":
      print("Ok...")
      break
    if player_name_choice == "n" or player_name_choice == "N":
      player_name = input('あなたの名前は何ですか？:')
  else:
    print("You do not type anything, try again")
    player_name = input('あなたの名前は何ですか？:')

#easter eggs for name
if player_name == 'Meriwether Lewis':
  year_set = 1803
  mode_choice = 'impossible'
else:
  year_set = input('お好きな年を入力してください:')
  if year_set.isdigit():
    return_num = 0
  else:
    return_num = 1
  while return_num == 1:
    print('エラーです。もう一度試してください！')
    year_set = input('お好きな年を入力してください:')
    if year_set.isdigit():
      return_num = 0
    else:
      return_num = 1
  year_set = int(year_set)
  print('どのモードでプレイしますか？')
  mode_choice = input('(簡単,普通,難しい,不可能,カスタマイズ):')

#leap year function
#go to [https://github.com/yoshino-lin/Oregon-Trail] to support me!
'''
if (year_set % 4) == 0:
   if (year_set % 100) == 0:
       if (year_set % 400) == 0:
           print('leap year')
       else:
           print('no leap year')
   else:
       print('leap year')
else:
   print('no leap year')
'''

while len(mode_choice) >= 0: 
#easy mode:
  if mode_choice == 'easy':
    food_num = 1000
    health_num = 10
    break
#noraml mode:
  elif mode_choice == 'normal':
    food_num = 500
    health_num = 5
    break
#hard mode:
  elif mode_choice == 'hard':
    food_num = 300
    health_num = 4
    break
#impossible mode:
  elif mode_choice == 'impossible':
    food_num = 150
    health_num = 3
    break
#customize mode:
  elif mode_choice == 'customize':
    #food number take in
    food_num = input('どれくらいの食料が欲しいですか:')
    if food_num.isdigit():
      return_cm_num = 0
    else:
      return_cm_num = 1
    while return_cm_num == 1:
      print('エラーです。もう一度試してください！')
      food_num = input('どれくらいの食料が欲しいですか:')
      if food_num.isdigit():
        return_cm_num = 0
      else:
        return_cn_num = 1
    food_num = int(food_num)
    #health number take in
    health_num = input('どれくらいの体力が欲しいですか:')
    if health_num.isdigit():
      return_cm_num2 = 0
    else:
      return_cm_num2 = 1
    while return_cm_num2 == 1:
      print('エラーです。もう一度試してください！')
      health_num = input('どれくらいの体力が欲しいですか:')
      if health_num.isdigit():
        return_cm_num2 = 0
      else:
        return_cn_num2 = 1
    health_num = int(health_num)
    break
#erro?
  else:
    print("Bad input, try again!")
    mode_choice = input('(簡単,普通,難しい,不可能,カスタマイズ):')
    

#other basic strating value setting
player_move_distance = 0
month_num = 3
days_pass = 1
total_days = 0
MONTHS_WITH_31_DAYS = [1, 3, 5, 7, 8, 10, 12]
random_result = 0
health_d1 = random.randint(1, 31)
health_d2 = random.randint(1, 31)
acident_appear = random.randint(1, 30)
travel_total_num = 0
rest_total_num = 0
hunt_total_num = 0
status_total_num = 0
month_appear = 'March'

#add days:
def add_days(min, max):
  global days_pass
  global month_num
  global MONTHS_WITH_31_DAYS
  global random_result
  global food_num
  global health_num
  global health_d1
  global health_d2
  global total_days
  global acident_appear

  random_result = random.randint(min, max)
  print('現在',random_result,"days passed..")
  days_pass_min = days_pass
  check_big = days_pass + random_result

  #acident
  if acident_appear >= days_pass and acident_appear <= check_big:
    a_number = random.randint(1, 3)
    a_health_num = random.randint(1, 2)
    if a_number == 1:
      print('この期間中に川を渡りました。')
    if a_number == 2:
      print('この期間中に赤痢にかかりました。')
    if a_number == 3:
      print('この期間中、美しい女性に会い、楽しい時間を過ごしました。')
    random_result2_food = random.randint(1, 10)
    random_result2_day = random.randint(1, 10)
    print('その結果、あなたは'+str(random_result2_food)+'ポンドの余分な食料を消費しました。')
    print('また、追加で'+str(random_result2_day)+'日かかりました。')
    if a_health_num == 1:
      print('さらに、体力が1減少しました。')
      health_num -= 1
    food_num = food_num - random_result2_food - random_result2_day*5
    days_pass += random_result2_day
    total_days += random_result2_day
  #health decrease randomly  
  check_big = days_pass + random_result
  if health_d1 >= days_pass_min and health_d1 <= check_big:
    health_num -= 1
    print('残念ながら、この期間中に体力が1減少しました。')
  if health_d2 >= days_pass_min and health_d2 <= check_big:
    health_num -= 1
    print('残念ながら、この期間中に体力が1減少しました。')


  days_pass += random_result
  total_days += random_result
  food_num -= random_result * 5

  if days_pass >= 30:
    if month_num not in MONTHS_WITH_31_DAYS:
      if days_pass > 30:
        days_pass -= 30
        month_num += 1
        health_d1 = random.randint(1, 30)
        health_d2 = random.randint(1, 30)
        acident_appear == random.randint(1, 30)
    else:
      if days_pass > 31:
        days_pass -= 31
        month_num += 1
        health_d1 = random.randint(1, 30)
        health_d2 = random.randint(1, 30)
        acident_appear == random.randint(1, 30)

#function part
def travle1(movedistance):
  global days_pass
  global travel_total_num
  add_days(3,7)
  movedistance = movedistance + random.randint(30, 60)
  travel_total_num += 1
  return movedistance

def rest(health):
  global days_pass
  global rest_total_num
  add_days(2,5)
  health = health + 1
  rest_total_num += 1
  return health

def hunt(hunting_food):
  global days_pass
  global hunt_total_num
  add_days(2,5)
  hunting_food = hunting_food + 100
  print('獲得: 100ポンドの食料')
  hunt_total_num += 1
  return hunting_food

#month_appear
def month_appear_fun():
  global month_appear
  if month_num == 1:
    month_appear = 'January'
  elif month_num == 2:
    month_appear = 'February'
  elif month_num == 3:
    month_appear = 'March'
  elif month_num == 4:
    month_appear = 'April'
  elif month_num == 5:
    month_appear = 'May'
  elif month_num == 6:
    month_appear = 'June'
  elif month_num == 7:
    month_appear = 'July'
  elif month_num == 8:
    month_appear = 'August'
  elif month_num == 9:
    month_appear = 'September'
  elif month_num == 10:
    month_appear = 'October'
  elif month_num == 11:
    month_appear = 'November'
  elif month_num == 12:
    month_appear = 'December'
  return month_appear

#loading part
print('--------------------------------------')
print('Now Loding...')
time.sleep(0.5)
print('Now loading the player setting...')
time.sleep(2)
print('Successfully!')
time.sleep(0.5)
print('Now loading the game setting...')
time.sleep(2)
print('Successfully!')
time.sleep(0.5)
print('Prepearing the trip for Oregon...')
time.sleep(2)
print('Successfully!')
time.sleep(0.5)
print('Now game is ready!')
print('--------------------------------------')
print('Attention:')
print('We will be recreating Oregon Trail! The goal is to travel from NYC to')
print('Oregon (2000 miles) by Dec 31st. However, the trail is arduous. Each')
print('day costs you food and health. You can huntand rest, but you have to')
print('get there before winter. GOOD LUCK!')
print('--------------------------------------')

#main
while player_move_distance < 2000 and food_num > 0 and health_num > 0 and month_num < 13:
  month_appear_fun()
  if food_num <= 50:
    print('警告！あなたは現在'+ str(food_num) + " lbs food now.")
    print('狩りが必要です。')
  if health_num <= 2:
    print('警告！あなたは現在'+ str(health_num) + " health now.")
    print('休息が必要です。')
  print(str(player_name) + '、現在の日時は' + month_appear + ' '+str(days_pass) + ', ' + str(year_set) + ", and you have travled " + str(player_move_distance) + " miles.")
  choice = input('あなたの選択:')
  if choice == 'travel':
    player_move_distance = travle1(player_move_distance)
  elif choice == 'rest':
    if health_num < 5:
      print("You get 1 heath!")
      health_num = rest(health_num)
    if health_num >= 5:
      print("Your health is full, the maximum number for health is 5!")
  elif choice == 'hunt':
    food_num = hunt(food_num)
  elif choice == 'status':
    print('-親愛なる' + str(player_name) + '、現在の日時は'+str(month_num)+'/'+str(days_pass)+'/'+str(year_set)+".")
    print('-食料:',food_num,"lbs")
    print('-体力:',health_num)
    print('-移動距離:',player_move_distance)
    distance_left = 2000 - player_move_distance
    print('-'+str(total_days) +'日が経過しました。')
    print('-You have travled ' + str(player_move_distance) + " miles, there is still " + str(distance_left) + 'マイルの距離があります。')
    status_total_num += 1
  elif choice == 'help':
    print('[移動]: ランダムで30-60マイル移動し、3-7日を要します（ランダム）。')
    print('[休息]: 体力を1回復（最大5まで）し、2-5日を要します（ランダム）。')
    print('[狩り]: 100ポンドの食料を追加し、2-5日を要します（ランダム）。')
    print('[状況]: 食料、体力、移動距離、日数を表示します。')
    print('[終了]: ゲームを終了します。')
  elif choice == 'quit':
    quit_choice = input('本当に終了しますか？(y/n):')
    if quit_choice == 'y':
      print('ゲームオーバー...あなたが終了したなんて信じられません...')
      break
  elif choice == 'suicide':
    quit_choice2 = input('本当ですか？(y/n):')
    if quit_choice2 == 'y':
      print('ゲームオーバー...あなたは自殺しました...')
      break
  elif choice == 'easter egg':
    print("　　　　　　　　　　　　　＿＿＿ r -v ､ _＿＿＿")
    print("　　　　　　　　- ﾆ 二_ ` ､_::: -‐`…‐'´- _::::::::::::::7")
    print("　　　　　　　　__ 　-―` 　　　　　　　　　　｀ヽ:::/")
    print("　　　 　 　,. ´　　,. 　´　　　　　　　　　　　　 　＼")
    print("　　 　 ／　 __ ／　　　　　/　 /　　　　　　　　ヽ　ヽ.")
    print("　　　/'´￣ ／'　　 /　　 /　 / / ∧　 |　　　　　∨ ﾊ")
    print("　　　　　　//　 　/　 　/　 ｲ　'　| 　!　ﾄ　＼　　　∨ l")
    print("　 　 　　 /ｲ 　　,′　ｨ ⌒　|　|　| 　!　l　⌒ ヽ 　|　V")
    print("　　　　 〃 |　　│ 　 |　/ 　|　|　| 　 V 　　＼|　 |　　',")
    print("　 　 　 l! 　ﾚ　　|　　 |/_＿　V 　 　 　　 _ ＿|,_　ﾄ､ 　 ,")
    print("　　　　　　 |　　 |　　/ヾi ￣`r　 　　 　彳´￣ﾊ　ﾚ ヽ　l")
    print("　　　　　　 |　/|∧ ∧ 　VU`l 　 　　 　 l'ひV　!│ l　ヽ!")
    print("　　　　　　 ﾚ'　l　 !　ﾊ 　ゝ- ' / / / // ｀　´ ∧.ﾚ′")
    print("　　　　　　　　　　 V　ゝ　　　　 　 　　 　　 ノ ´ﾚ′")
    print("　　　　　　　 　　　　 　 　＞ .. _　 ´　_ .. ィ")
    print("　 　　 　 　 　　　 　　 　　_|ノ^､l ￣ l∧　|")
    print("　　　　 　 　　 　 　ィ´　丁| i ヽヽ_ _// ﾊ￣/ ヽ")
    print("　　　 　　 　　 　 /│　　V| i　 ゝ--く / ハ′ ハ")
    print("　　　　　　　　 　l　 ヽ　　|　ゝハ:::::::ハ │|　/　 |")
    print('verson:1.3.1')
    print('author: Yudong Lin')
    print('Good at: Game world view disign and value balance for the game')
    print('Have three-year-experience on developing and maintaining minecraft server')
    print('Technical nerd change the world!')
    print('Any bug reports please email:yoshino1347716570@gmail.com')
    print('Thanks for playing!')
  else:
    print("This Choice is not available, please try again.")
  print('--------------------------------------')
#succeed!
if player_move_distance >= 2000:
  print('素晴らしい！あなたはオレゴンに到着しました')

#game over
if food_num <= 0:
  print('ゲームオーバー、食料が尽きました。')

if health_num <= 0:
  print('ゲームオーバー、体力が尽きました。')

if month_num >= 13:
  print('ゲームオーバー、時間切れです！')
  
print('ゲーム全体を通して、あなたは:')
print('移動 ' + str(travel_total_num) +' 回。')
print('休息 ' + str(rest_total_num) +' 回。')
print('狩り ' + str(hunt_total_num) +' 回。')
print('状況 ' + str(status_total_num) +' 回。')

#restart
#restart_choice = input('ゲームを再開しますか？')
