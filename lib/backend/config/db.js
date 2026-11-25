const mongoose = require('mongoose');

async function connecter() {
    const uri = process.env.MONGO_URI;
    if (!uri) {
        throw new Error('MONGO_URI manquant : copie .env.example vers .env');
    }
    await mongoose.connect(uri);
    console.log('MongoDB connectée');
}

module.exports = { connecter };