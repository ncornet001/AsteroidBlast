import cv2
import mediapipe as mp
import pyautogui
import math

mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands
screen_width, screen_height = pyautogui.size()

cap = cv2.VideoCapture(0)
hand_x = 0.5
hand_y = 0.5

with mp_hands.Hands(
  min_detection_confidence=0.5,
  min_tracking_confidence=0.5) as hands:
  i = 0
  while (cap.isOpened()):
    success, image = cap.read()
    if not success:
      print("Impossible de lire la vidéo")
      break

    image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)
    image.flags.writeable = False
    results = hands.process(image)

    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    hand_closed = False
    if results.multi_hand_landmarks:
      for hand_landmarks in results.multi_hand_landmarks:
        wrist = hand_landmarks.landmark[mp_hands.HandLandmark.WRIST]
        thumb_tip = hand_landmarks.landmark[mp_hands.HandLandmark.THUMB_TIP]
        index_tip = hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP]
        distance = math.sqrt((wrist.x - thumb_tip.x)**2 + (wrist.y - thumb_tip.y)**2 + (wrist.z - thumb_tip.z)**2) + math.sqrt((wrist.x - index_tip.x)**2 + (wrist.y - index_tip.y)**2 + (wrist.z - index_tip.z)**2)
        mouse_x = max(5,min(screen_width-5,int(2*(wrist.x-0.5)*screen_width)))
        mouse_y = max(5,min(screen_height-5,int(2*(wrist.y-0.5)*screen_height)))
        #print(mouse_x,mouse_y)
        pyautogui.moveTo(mouse_x,mouse_y)
        if distance < 0.5:
            hand_closed = True

        mp_drawing.draw_landmarks(
            image, hand_landmarks, mp_hands.HAND_CONNECTIONS)
      

    #cv2.imshow('MediaPipe Hands', image)

    if cv2.waitKey(5) & 0xFF == 27:
      break

    #if(hand_closed):
      #pyautogui.click()
      #print("Main fermée :", hand_closed)
    i += 1
    print(i)

cap.release()
cv2.destroyAllWindows()