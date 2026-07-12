use fmt;
use settings;
use engine;

export fn accept(id: u32) void = {
    engine::editEntryStatus(id, engine::EntryStatus::ACCEPTED);
};

export fn reject(id: u32) void = {
    engine::editEntryStatus(id, engine::EntryStatus::REJECTED);
};

export fn supersede(id: u32, by: u32) void = {
    engine::editEntryStatus(id, engine::EntryStatus::SUPERSEDED);
    engine::addEntryRelation(by, engine::Relation{id = id, kind=engine::RelationType::SUPERSEDE});
};

export fn depends(id: u32, on: u32) void = {
    engine::addEntryRelation(id, engine::Relation{id = on, kind=engine::RelationType::DEPENDS});
};
