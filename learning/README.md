# Learning — software engineering and AI engineering

Lystiger learns by doing: each pipeline stage we build comes with the reading that explains it. Run `/coach` in Claude Code to start a session.

## Order, and why
Learn just in time. Read the chapter that matches the stage you are building now, use it right away, then discuss it. Don't read cover to cover first.

| # | Book | Why this one, now | Read with |
|---|---|---|---|
| 1 | *Software Engineering at Google* (Winters, Manshreck, Wright). Free at abseil.io/resources/swe-book | Its chapters are this pipeline: design docs, testing, code review, CI, continuous delivery. | each pipeline stage, as it gets built |
| 2 | *A Philosophy of Software Design* (Ousterhout) | Short. How to judge a design: complexity, deep modules, information hiding. Needed to write and review specs. | the step 3 spec, and later specs |
| 3 | *AI Engineering* (Chip Huyen) | Building on foundation models: evaluation, agents, failure modes. Needed to judge agents fairly. | the A-vs-B comparison (P8) and the verifier gates |
| 4 | *Designing Data-Intensive Applications* (Kleppmann) | Systems: storage, consistency, failure. Later, once the pipeline holds state and runs a real product. | the pipeline-state decision, Unigreen |

## Map: pipeline stage → chapter
| Stage | SWE at Google | Other |
|---|---|---|
| Spec | Design docs (Documentation chapter) | Ousterhout ch. 1–4 |
| TDD | Testing Overview; Unit Testing | |
| Build and harden | Code Review | Ousterhout: deep modules |
| Verify | Code Review; Larger Testing | Huyen: evaluation |
| CI | Continuous Integration | |
| Staging and prod | Continuous Delivery | |
| Decisions | Knowledge Sharing | ADRs (Michael Nygard, "Documenting Architecture Decisions") |

## Log
One line per session: date, topic, what Lystiger can now do on their own, and what is next.

| Date | Topic | Can now do alone | Next |
|---|---|---|---|
