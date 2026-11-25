const express = require('express');
const Mot = require('../models/Mot');
const { middlewareValidation } = require('../middleware/validation');

const router = express.Router();

function erreursMongoose(e) {
    if (e.errors) return Object.values(e.errors).map((x) => x.message);
    return [e.message];
}

// GET /api/themes -> [{ nom, total }] pour l'écran Statistiques.
router.get('/themes', async (req, res) => {
    try {
        const mots = await Mot.find().select('theme -_id');
        const groupes = {};
        for (const m of mots) {
            groupes[m.theme] = (groupes[m.theme] || 0) + 1;
        }
        res.json(
            Object.entries(groupes).map(([nom, total]) => ({ nom, total }))
        );
    } catch (e) {
        res.status(500).json({ erreurs: [e.message] });
    }
});

// GET /api/mots -> tous les mots.
router.get('/mots', async (req, res) => {
    try {
        res.json(await Mot.find().sort({ id: 1 }));
    } catch (e) {
        res.status(500).json({ erreurs: [e.message] });
    }
});

// GET /api/mots/:id -> un mot.
router.get('/mots/:id', async (req, res) => {
    try {
        const mot = await Mot.findOne({ id: Number(req.params.id) });
        if (!mot) return res.status(404).json({ erreurs: ['Mot introuvable'] });
        res.json(mot);
    } catch (e) {
        res.status(500).json({ erreurs: [e.message] });
    }
});

// POST /api/mots -> ajouter un mot (validation avant insertion).
router.post('/mots', middlewareValidation, async (req, res) => {
    try {
        const count = await Mot.countDocuments();
        const mot = new Mot({ id: count + 1, ...req.body });
        await mot.save();
        res.status(201).json(mot);
    } catch (e) {
        res.status(400).json({ erreurs: erreursMongoose(e) });
    }
});

// PUT /api/mots/:id -> modifier un mot.
router.put('/mots/:id', middlewareValidation, async (req, res) => {
    try {
        const mot = await Mot.findOneAndUpdate(
            { id: Number(req.params.id) },
            req.body,
            { new: true, runValidators: true }
        );
        if (!mot) return res.status(404).json({ erreurs: ['Mot introuvable'] });
        res.json(mot);
    } catch (e) {
        res.status(400).json({ erreurs: erreursMongoose(e) });
    }
});

// DELETE /api/mots/:id -> supprimer un mot.
router.delete('/mots/:id', async (req, res) => {
    try {
        const mot = await Mot.findOneAndDelete({ id: Number(req.params.id) });
        if (!mot) return res.status(404).json({ erreurs: ['Mot introuvable'] });
        res.json({ message: 'Mot supprimé', id: mot.id });
    } catch (e) {
        res.status(500).json({ erreurs: [e.message] });
    }
});

module.exports = router;