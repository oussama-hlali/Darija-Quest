require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { connecter } = require('./config/db');
const routesMots = require('./routes/mots');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.json({ message: 'API Darija Quest OK' });
});

app.use('/api', routesMots);

// Erreur 404 simple.
app.use((req, res) => {
    res.status(404).json({ erreurs: ['Route introuvable'] });
});

// Erreurs serveur.
app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).json({ erreurs: ['Erreur serveur'] });
});

const PORT = process.env.PORT || 10000;

connecter()
    .then(() => {
        app.listen(PORT, () => console.log(`API lancée sur le port ${PORT}`));
    })
    .catch((e) => {
        console.error(e.message);
        process.exit(1);
    });
module.exports = app;