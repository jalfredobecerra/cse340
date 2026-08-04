import db from './db.js'

/**
 * Adds a user as a volunteer for a service project.
 * @param {string} userId - The ID of the volunteering user.
 * @param {string} projectId - The ID of the project.
 */
const addVolunteer = async (userId, projectId) => {
    const query = `
        INSERT INTO volunteer (user_id, project_id)
        VALUES ($1, $2);
    `;

    await db.query(query, [userId, projectId]);
};

/**
 * Removes a user as a volunteer from a service project.
 * @param {string} userId - The ID of the user.
 * @param {string} projectId - The ID of the project.
 */
const removeVolunteer = async (userId, projectId) => {
    const query = `
        DELETE FROM volunteer
        WHERE user_id = $1 AND project_id = $2;
    `;

    await db.query(query, [userId, projectId]);
};

/**
 * Retrieves all projects a given user has volunteered for.
 * @param {string} userId - The ID of the user.
 * @returns {object[]} Array of project objects the user has volunteered for.
 */
const getVolunteerProjectsByUserId = async (userId) => {
    const query = `
        SELECT sp.project_id, sp.title, sp.project_date AS date, sp.location, sp.organization_id, o.name AS organization_name
        FROM public.service_project sp
        JOIN public.volunteer v ON v.project_id = sp.project_id
        JOIN public.organization o ON o.organization_id = sp.organization_id
        WHERE v.user_id = $1
        ORDER BY sp.project_date;
    `;

    const result = await db.query(query, [userId]);

    return result.rows;
};

/**
 * Checks whether a given user is currently volunteering for a given project.
 * @param {string} userId - The ID of the user.
 * @param {string} projectId - The ID of the project.
 * @returns {boolean} True if the user is volunteering for the project.
 */
const isUserVolunteering = async (userId, projectId) => {
    const query = `
        SELECT 1
        FROM public.volunteer
        WHERE user_id = $1 AND project_id = $2;
    `;

    const result = await db.query(query, [userId, projectId]);

    return result.rows.length > 0;
};

export { addVolunteer, removeVolunteer, getVolunteerProjectsByUserId, isUserVolunteering };