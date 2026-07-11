CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES (
        'BrightFuture Builders',
        'A nonprofit focused on improving community infrastructure through sustainable construction projects.',
        'info@brightfuturebuilders.org',
        'brightfuture-logo.png'
    ),
    (
        'GreenHarvest Growers',
        'An urban farming collective promoting food sustainability and education in local neighborhoods.',
        'contact@greenharvest.org',
        'greenharvest-logo.png'
    ),
    (
        'UnityServe Volunteers',
        'A volunteer coordination group supporting local charities and service initiatives.',
        'hello@unityserve.org',
        'unityserve-logo.png'
    );

CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id),
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    project_date DATE NOT NULL
);

INSERT INTO service_project (organization_id, title, description, location, project_date)
VALUES
    -- BrightFuture Builders (1)
    (1, 'Park Cleanup', 'Join us to clean up local parks and make them beautiful for the community.', 'Riverside Park', '2026-08-15'),
    (1, 'Habitat Build Day', 'Help construct affordable housing alongside skilled volunteers.', '412 Maple Street', '2026-08-22'),
    (1, 'Neighborhood Mural Project', 'Paint a community mural celebrating local history and culture.', 'Downtown Community Center', '2026-09-05'),
    (1, 'Playground Renovation', 'Repair and repaint equipment at a local elementary school playground.', 'Lincoln Elementary School', '2026-09-19'),
    (1, 'Senior Home Repairs', 'Assist elderly residents with minor home repairs and yard work.', 'Oakwood Senior Community', '2026-10-03'),

    -- GreenHarvest Growers (2)
    (2, 'Community Garden Planting', 'Plant vegetables and herbs in the shared community garden plots.', 'Elmwood Community Garden', '2026-08-10'),
    (2, 'Farmers Market Volunteer Day', 'Help set up and run the weekly farmers market booth.', 'Town Square', '2026-08-24'),
    (2, 'Composting Workshop', 'Teach households how to start composting to reduce food waste.', 'GreenHarvest Learning Center', '2026-09-07'),
    (2, 'Fruit Tree Planting Initiative', 'Plant fruit trees along public walking trails for future harvests.', 'Cedar Creek Trail', '2026-09-21'),
    (2, 'Harvest Food Bank Drop-off', 'Harvest and deliver fresh produce to the local food bank.', 'GreenHarvest Farm', '2026-10-05'),

    -- UnityServe Volunteers (3)
    (3, 'Food Drive', 'Help collect and distribute food to those in need.', 'UnityServe Distribution Center', '2026-08-12'),
    (3, 'Community Tutoring', 'Volunteer to tutor students in math, reading, and science.', 'Jefferson Public Library', '2026-08-26'),
    (3, 'Winter Coat Collection', 'Gather and sort donated coats for families in need this winter.', 'UnityServe Main Office', '2026-09-09'),
    (3, 'Homeless Shelter Meal Service', 'Prepare and serve meals at the downtown homeless shelter.', 'Hope Street Shelter', '2026-09-23'),
    (3, 'Youth Mentorship Kickoff', 'Launch a new mentorship program pairing volunteers with local youth.', 'Community Youth Center', '2026-10-07');

CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE project_category (
    project_id INTEGER NOT NULL REFERENCES service_project(project_id),
    category_id INTEGER NOT NULL REFERENCES category(category_id),
    PRIMARY KEY (project_id, category_id)
);

INSERT INTO category (name) VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service'),
    ('Health and Wellness');

-- Associate every project with at least one category
INSERT INTO project_category (project_id, category_id) VALUES
    -- BrightFuture Builders projects
    (1, 3),  -- Park Cleanup -> Community Service
    (1, 1),  -- Park Cleanup -> Environmental
    (2, 3),  -- Habitat Build Day -> Community Service
    (3, 3),  -- Neighborhood Mural Project -> Community Service
    (4, 3),  -- Playground Renovation -> Community Service
    (4, 4),  -- Playground Renovation -> Health and Wellness
    (5, 3),  -- Senior Home Repairs -> Community Service
    (5, 4),  -- Senior Home Repairs -> Health and Wellness

    -- GreenHarvest Growers projects
    (6, 1),  -- Community Garden Planting -> Environmental
    (7, 1),  -- Farmers Market Volunteer Day -> Environmental
    (8, 1),  -- Composting Workshop -> Environmental
    (8, 2),  -- Composting Workshop -> Educational
    (9, 1),  -- Fruit Tree Planting Initiative -> Environmental
    (10, 1), -- Harvest Food Bank Drop-off -> Environmental
    (10, 4), -- Harvest Food Bank Drop-off -> Health and Wellness

    -- UnityServe Volunteers projects
    (11, 3), -- Food Drive -> Community Service
    (11, 4), -- Food Drive -> Health and Wellness
    (12, 2), -- Community Tutoring -> Educational
    (13, 3), -- Winter Coat Collection -> Community Service
    (14, 3), -- Homeless Shelter Meal Service -> Community Service
    (14, 4), -- Homeless Shelter Meal Service -> Health and Wellness
    (15, 2); -- Youth Mentorship Kickoff -> Educational