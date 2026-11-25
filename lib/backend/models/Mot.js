const mongoose = require('mongoose');

// Un mot = un document MongoDB. Les noms de champs sont ceux de l'app Flutter.
const motSchema = new mongoose.Schema(
    {
        id: { type: Number, required: true, unique: true },
        darija: {
            type: String,
            required: [true, 'Le mot en darija est obligatoire'],
            trim: true,
            minlength: [2, 'Au moins 2 caractères'],
        },
        arabe: { type: String, default: '' },
        francais: {
            type: String,
            required: [true, 'La traduction est obligatoire'],
            trim: true,
        },
        niveau: {
            type: String,
            enum: ['Débutant', 'Intermédiaire', 'Avancé'],
            default: 'Débutant',
        },
        exemple: { type: String, default: '' },
        exemplefr: { type: String, default: '' },
        theme: { type: String, default: 'Salutations' },
    },
    { versionKey: false }
);

module.exports = mongoose.model('Mot', motSchema);