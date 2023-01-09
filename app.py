from flask import Flask,request,jsonify,send_file
import cv2
import imutils
import numpy as np
import base64
import json
import werkzeug
import pytesseract
from PIL import Image
app = Flask(__name__)

@app.route("/anpr",methods = ['GET','POST'])

def upload():
    pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files (x86)\Tesseract-OCR\tesseract.exe'
    if(request.method == 'POST'):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save("./uploadedimages/"+filename)
        text= imageProcessing(filename)
        print(text)
        return jsonify({
            "message" : text,
        })
    if(request.method == 'GET'):
        return send_file(r"C:\Users\ROG G512\Desktop\mini project final\numplate.jpeg")



def imageProcessing(filename):
    try:
        img = cv2.imread(r"./uploadedimages/"+filename,cv2.IMREAD_COLOR)
        img = cv2.resize(img, (600,400))

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # cv2.imshow('gray',gray)
        # cv2.imwrite('grayscale.jpeg', gray)

        gray = cv2.bilateralFilter(gray, 13, 15, 15) 

        # cv2.imshow('bilateral gray',gray)
        # cv2.imwrite('bilateral.jpeg', gray)

        edged = cv2.Canny(gray, 30, 200) 
        contours = cv2.findContours(edged.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contours = imutils.grab_contours(contours)
        contours = sorted(contours, key = cv2.contourArea, reverse = True)[:10]
        screenCnt = None

        # cv2.imshow('conturs', edged)
        # cv2.imwrite('contours.jpeg', edged)


        for c in contours:
            
            peri = cv2.arcLength(c, True)
            approx = cv2.approxPolyDP(c, 0.018 * peri, True)
        
            if len(approx) == 4:
                screenCnt = approx
                break

        if screenCnt is None:
            detected = 0
            print ("No contour detected")
        else:
            detected = 1

        if detected == 1:
            cv2.drawContours(img, [screenCnt], -1, (0, 0, 255), 3)

        mask = np.zeros(gray.shape,np.uint8)
        new_image = cv2.drawContours(mask,[screenCnt],0,255,-1,)
        new_image = cv2.bitwise_and(img,img,mask=mask)


        (x, y) = np.where(mask == 255)
        (topx, topy) = (np.min(x), np.min(y))
        (bottomx, bottomy) = (np.max(x), np.max(y))
        Cropped = gray[topx:bottomx+1, topy:bottomy+1]

        # text = pytesseract.image_to_string(Cropped, config='--psm 7')
        text = pytesseract.image_to_string(Cropped, config='-c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ --psm 7 --oem 3')
        print(text)
        if len(text) == 0:
            print("Not detected!")
        else:
            print("Detected license plate Number is:",text)

        print("Detected license plate Number is:",text)
        img = cv2.resize(img,(500,300))
        Cropped = cv2.resize(Cropped,(400,200))
        # cv2.imshow('car',img)
        # cv2.imwrite("result.jpeg",img)
        # cv2.imshow('Cropped',Cropped)
        cv2.imwrite('numplate.jpeg', Cropped)
        # path = r"C:\Users\ROG G512\Desktop\anpr_app\numplate.jpeg"
        cv2.waitKey(0)
        cv2.destroyAllWindows()
        # d = dict()
        # d['text'] = text
        # d['image'] =Cropped
        return text
    except:
        errorText = "Licence plate not detected!"
        return errorText
    # ,send_file(path_or_file="C:\Users\ROG G512\Desktop\anpr_app\numplate.jpeg",download_name="numplate.jpeg")

# app.run(debug=True)
if __name__ == "main":
    app.run()