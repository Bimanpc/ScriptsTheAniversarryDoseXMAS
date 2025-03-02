from telegram import Update
from telegram.ext import Updater, CommandHandler, CallbackContext

TOKEN = "YOUR_BOT_TOKEN"

def start(update: Update, context: CallbackContext):
    update.message.reply_text("Hello! I am your bot.")

def main():
    updater = Updater(TOKEN)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("start", start))
    updater.start_polling()
    updater.idle()

if __name__ == "__main__":
    main()
