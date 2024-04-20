CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE features (
    id SERIAL PRIMARY KEY,
    external_id VARCHAR(255),
    magnitude FLOAT,
    place VARCHAR(255),
    time TIMESTAMP,
    url VARCHAR(255),
    tsunami BOOLEAN,
    mag_type VARCHAR(255),
    title VARCHAR(255),
    longitude FLOAT,
    latitude FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    body TEXT,
    feature_id INTEGER REFERENCES features(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
