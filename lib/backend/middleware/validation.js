// Validation simple des données envoyées à l'API .
function validerMot(body) {
    const erreurs = [];

    if (!body.darija || !body.darija.trim()) {
        erreurs.push('Le champ darija est obligatoire');
    }
    if (!body.francais || !body.francais.trim()) {
        erreurs.push('Le champ francais est obligatoire');
    }
    if (
        body.niveau &&
        !['Débutant', 'Intermédiaire', 'Avancé'].includes(body.niveau)
    ) {
        erreurs.push('Niveau invalide');
    }

    return erreurs;
}

function middlewareValidation(req, res, next) {
    const erreurs = validerMot(req.body);
    if (erreurs.length > 0) {
        return res.status(400).json({ erreurs });
    }
    next();
}

module.exports = { validerMot, middlewareValidation };