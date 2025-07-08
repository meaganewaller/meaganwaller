---
date:   2025-07-07
layout: post
title:  The Problem With Rails Concerns Is Not What You Think (Part One)
summary: You're not cleaning up your models, you're avoiding harder architectural decisions.
---

In Rails, concerns are often pitched as a solution to "fat models." You've heard the trope:

> "Skinny controllers, skinny models, fat nothing."

So when your `User` model tips over 300 lines, the move is obvious: break things into concerns. `Authenticatable`, `Exportable`, `Trackable`, `Notifiable`. Each gets its own file. Your model shrinks to a tidy list of `include`s. You feel good. Maybe even a little smug.

But here's the thing: **Concerns aren't fixing your boundaries. They're just hiding the evidence that you don't have any.**

They give the illusion of modularity, while quietly making your system harder to understand, harder to debug, and much harder to scale. The real problem isn't that your models are fat, it's that you're avoiding boundaries by reaching for mixins.

Let's talk about what that actually does to your codebase.

## Mixins Flatten Your Object Graph

The problem with concerns isn’t just where the code lives.
It’s how they distort the shape of your system.

Concerns are mixins. Mixins don’t add structure, they smear behavior. They inject methods into classes without making relationships explicit. That might feel convenient on day one, but by day 500? You’re playing method whack-a-mole.

You call `user.can_export_csv?` and it _just works_. But where is it defined? Not in `User`. Not in a service. It’s in a concern. That concern includes another concern. That one defines a callback. That callback triggers the method you were originally trying to debug. Somewhere in that chain, something breaks.

Now your mental model looks like this:

> “Okay, the method is defined in this concern, but that concern is only included in one place…unless it’s included in `AdminUser` too…which it is…but with different _behavior_ because it overrides a method from another concern…”

This is the illusion of locality. Concerns make every method feel “close”, but that’s because everything has been shoved into the same namespace.

You’re no longer thinking in objects with clear responsibilities.
You’re thinking in terms of method reachability.

## Mixins Break Domain Shape

In a well-structured application, you can draw your object graph.

"This service depends on this model. This model delegates to this value object. This query fetches this shape of data."

It’s mappable. Legible.

With concerns? That shape disappears.

```rb
class Invoice < ApplicationRecord
  include Billable
  include Exportable
  include SoftDeletable
end
```

This looks neat. But those modules aren’t traits. They aren’t decorators. They’re just collections of methods and callbacks dumped into the `Invoice` namespace.

Open `Billable`, and you’ll probably find:

- Scopes
- Associations
- Side effects
- Data mutations
- Business logic
- Callback chains

It’s not a utility module. It’s a hidden collaborator. And it's got opinions.

Instead of creating new objects and defining how they relate to each other, you’ve just pasted more behavior onto the same pile. You've flattened your object graph into a **blob**. That blob might behave. It might even work. But it won’t tell you anything about the system it's in.

## The Trap Is Psychological


The worst part? Concerns feel like the right decision—because Rails encourages it. Concerns:

- Reduce line counts
- Improve test coverage optics
- Look organized in your file tree
- Pass code review because they’re “idiomatic”

But none of that reflects actual architectural health. Concerns don’t help you answer:

- Who owns this logic?
- Where should a new behavior go?
- What depends on this?
- What am I safe to change?

Concerns don’t make your app simpler. They just make it look simpler (until you need to understand it).

## How This Fails in Practice

Let’s say you’ve got a `User` model that includes a `Notifiable` concern.

That concern handles:

- Preference storage
- Email delivery logic
- SMS fallbacks
- Auditing
- Scheduling

Now imagine your product team says: “Only enterprise users should get SMS notifications, and only during business hours, unless it’s a security event, and…”

Where do you put that logic?

- Do you keep bloating `Notifiable`?
- Do you fork it into `EnterpriseNotifiable`?
- Do you pass conditionals down into model methods?

No matter what you choose, it’s going to hurt—because your concern was never a proper boundary. It was just a collection of convenience methods pretending to be a concept.

You didn’t encapsulate. You compressed.


## "But It Keeps My Models Clean!"

It doesn’t. It just moves the mess.

Every concern you extract without clear boundaries is debt you’ve deferred. Every callback, every stateful method, every conditional that lives in a concern is a signal that you need a real object with a name and a real relationship.

This doesn’t mean you should never use concerns. It means you should stop using them as a first response to complexity.

If a concern contains:

- Multiple callbacks
- Scopes + mutations
- Side effects
- Behavior that only makes sense in one domain context

…it’s not a concern. It’s an object. You just haven’t given it a home yet.

## Coming in Part Two...

We’ll talk about what to do instead. Including:

- How to use service objects, policies, value objects, and presenters as structural alternatives to concerns
- When a concern is _actually_ appropriate
- A tactical guide for refactoring concerns into composable architecture, with minimal pain

The goal isn’t purity. It’s legibility. You should be able to explain your code to a teammate without a whiteboard and a prayer.

If your concerns make that easier, great.
But if they’re just hiding complexity behind cute filenames—it’s time to level up.






<!--
## Concerns as Coping Mechanism

To be clear, concerns aren't inherently bad. They’re a tool that Rails gives you to share behavior across models. But in most apps, they’re used less like surgical instruments and more like junk drawers.

Take this classic:

```rb
class Invoice < ApplicationRecord
  include Billable
  include Exportable
  include SoftDeletable
end
```

Looks clean. Looks modular.

Now open `concerns/billable.rb`:

```rb
module Billable
  extend ActiveSupport::Concern

  included do
    has_many :payments
    after_create :assign_invoice_number
    scope :overdue, -> { where('due_date < ?', Date.today) }
  end

  def total_due
    line_items.sum(&:total)
  end

  def mark_as_paid
    update!(paid_at: Time.current)
    Payment.create!(...)
  end
end
```

What is this _really_?

It's a second model. A shadow class. A backdoor entry point for behavior that should probably be isolated, or owned, or at least explained. Instead, it's mixed in and forgotten (until you have to debug it).

## Mixins Flatten Your Object Graph

The problem with concerns isn’t just where the code lives. It’s how they distort your ability to reason about the system.

Mixins collapse your object graph. They make every method feel “close,” even if it comes from somewhere totally unrelated. That might feel convenient on day one, but by day 500? You're playing method whack-a-mole.

On paper, concerns are "modular". They let you define reusable chunks of behavior, sprinkle them around your app, and keep your model files from ballooning. But what you gain in perceived tidiness, you lose in semantic clarity and explicit connections.

## Everything Is Everywhere All at Once

When you include a concern into a model, you're not composing objects so much as smearing behavior. You've taken a bunch of methods and dumped them into the same namespace, without clearly stating what owns what.

You call `user.can_export_csv?` and it _just works_. Until it doesn't.

Then you Cmd+Click into it and discover it's defined in a module named `Exportable`. That module, of course, includes other modules. That module uses callbacks. That callback triggers another method defined two modules over.

Now your mental stack looks like this:

> "Okay, the method is defined in this concern, but that concern is only included in one place...except it depends on another concern...which defines a callback...that fires _before_ the method I'm actually trying to debug. Cool."

This is the illusion of locality. Concerns make behavior feel "close", but that's because everything has been shoved into the same drawer.

## Mixins Break Object-Oriented Thinking

When everything is included everywhere, you stop thinking in objects. You stop asking:

- Who owns this behavior?
- What _role_ does this class play in the domain?
- What are the boundaries of this object?

Instead, you think:

> "Where is this method defined?"
> "Which concern is causing this callback to fire?"
> "Why does changing this thing in `Invoice` break `Subscription`?"

You lose all the benefits of OO when you trade it for duct tape pretending to be architecture.

## You're Losing the Shape of Your System

Good architecture is legible. You can draw it.

"This model talks to that model. This service coordinates those two things. This object makes a decision based on this value."

But concerns destroy that shape.

Because they’re **injected**, not composed, the object graph flattens into a pile of behaviors. Instead of meaningful edges and relationships, you get:

```txt
User
├── includes Authenticatable
├── includes RoleAssignable
├── includes Exportable
├── includes Trackable
```

Looks harmless. But these behaviors aren't small. They're complex, stateful, and interdependent.

What should be a clear representation of a domain concept becomes a grab bag of abilities.

## It Compounds Over Time

On day one, this architecture feels great. You've reduced duplication, split up files, followed The Rails Way™.

But on day 100? You can’t remember which method came from which module.

On day 300? You’re afraid to change anything in the concern because you don’t know who else includes it.

On day 500? A new hire asks, “Wait, where does this method actually live?” and your answer is “...uhhhh, let me grep real quick.”

This is technical debt in its purest form: a design decision that feels cheap now but becomes expensive later.

## TL;DR: Mixins Obscure Structure

With mixins:

- There’s no visibility into what depends on what.
- You can’t model your domain. You’re just naming buckets.
- You lose the ability to tell stories with your code when the narrative is scattered.

You haven't eliminated any complexity. You’ve just flattened it, obfuscated it, and hoped nobody trips on it later. -->

<!-- And someone always does. -->
