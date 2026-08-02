import db from './db.js'

const getAllCategories = async () => {
    const query = `
        SELECT category_id, name
        FROM public.category
        ORDER BY name;
    `;

    const result = await db.query(query);

    return result.rows;
}

const getCategoryDetails = async (categoryId) => {
    const query = `
        SELECT category_id, name
        FROM public.category
        WHERE category_id = $1;
    `;

    const result = await db.query(query, [categoryId]);

    return result.rows.length > 0 ? result.rows[0] : null;
}

const getCategoriesByProjectId = async (projectId) => {
    const query = `
        SELECT c.category_id, c.name
        FROM public.category c
        JOIN public.project_category pc ON pc.category_id = c.category_id
        WHERE pc.project_id = $1
        ORDER BY c.name;
    `;

    const result = await db.query(query, [projectId]);

    return result.rows;
}

const assignCategoryToProject = async (categoryId, projectId) => {
    const query = `
        INSERT INTO project_category (category_id, project_id)
        VALUES ($1, $2);
    `;

    await db.query(query, [categoryId, projectId]);
}

/**
 * Replaces all category assignments for a project with a new set.
 * @param {string} projectId - The ID of the project.
 * @param {string[]} categoryIds - Array of category IDs to assign to the project.
 */
const updateCategoryAssignments = async (projectId, categoryIds) => {
    const deleteQuery = `
        DELETE FROM project_category
        WHERE project_id = $1;
    `;
    await db.query(deleteQuery, [projectId]);

    for (const categoryId of categoryIds) {
        await assignCategoryToProject(categoryId, projectId);
    }
}

/**
 * Creates a new category in the database.
 * @param {string} name - The name of the category.
 * @returns {string} The id of the newly created category record.
 */
const createCategory = async (name) => {
    const query = `
      INSERT INTO category (name)
      VALUES ($1)
      RETURNING category_id;
    `;

    const result = await db.query(query, [name]);

    if (result.rows.length === 0) {
        throw new Error('Failed to create category');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Created new category with ID:', result.rows[0].category_id);
    }

    return result.rows[0].category_id;
}

/**
 * Updates an existing category in the database.
 * @param {string} categoryId - The ID of the category to update.
 * @param {string} name - The updated name of the category.
 * @returns {string} The id of the updated category record.
 */
const updateCategory = async (categoryId, name) => {
    const query = `
      UPDATE category
      SET name = $1
      WHERE category_id = $2
      RETURNING category_id;
    `;

    const result = await db.query(query, [name, categoryId]);

    if (result.rows.length === 0) {
        throw new Error('Category not found');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Updated category with ID:', categoryId);
    }

    return result.rows[0].category_id;
}

export { getAllCategories, getCategoryDetails, getCategoriesByProjectId, updateCategoryAssignments, createCategory, updateCategory };