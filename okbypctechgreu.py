import tkinter.messagebox
from tkinter import *

win=Tk() #creating the main window and storing the window object in 'win'
win.title('Welcome!!!!') #setting title of the window
win.geometry('500x300') #setting the size of the window

def func():#function of the button
    tkinter.messagebox.showinfo("Greetings","Hello! Welcome to Pythonpctegreugeeks.")
    
btn=Button(win,text="Click !!!", width=10,height=5,command=func)
btn.place(x=200,y=30)


win.mainloop() #running the loop that works as a trigger
