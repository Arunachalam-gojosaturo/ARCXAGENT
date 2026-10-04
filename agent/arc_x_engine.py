"""ARC X AGENT - Executive Intelligence & Enhancement Engine.

Provides autonomous task planning, proactive self-verification, and high-reliability
execution protocols for ARC X AGENT, respecting byte-stable prompt caching invariants.
"""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

logger = logging.getLogger(__name__)

ARC_X_VERSION = "2.0.0-executive"
ARC_X_IDENTITY = "ARC X AGENT"


@dataclass
class ArcXExecutiveConfig:
    """Configuration for ARC X Autonomous Executive Engine."""
    autonomous_verification: bool = True
    caching_protection: bool = True
    privacy_strict: bool = True
    max_substeps_per_turn: int = 15
    profile_scope: str = "default"
    custom_directives: List[str] = field(default_factory=list)


class ArcXExecutive:
    """The ARC X Executive Engine.
    
    Coordinates deep task reasoning, tool plan verification, and prompt-cache-safe
    context handling.
    """

    def __init__(self, config: Optional[ArcXExecutiveConfig] = None):
        self.config = config or ArcXExecutiveConfig()
        self._active_objectives: List[Dict[str, Any]] = []

    @property
    def identity(self) -> str:
        return ARC_X_IDENTITY

    def get_system_prompt_addon(self) -> str:
        """Return ARC X Executive system prompt instructions.
        
        Byte-stable and deterministic so prompt caching is fully preserved.
        """
        return (
            "\n## ARC X AGENT Executive Protocols\n"
            "- **Mission**: You are operating as ARC X AGENT, an advanced, highly capable autonomous AI system.\n"
            "- **Precision Execution**: Plan actions explicitly, check preconditions before mutation, and verify results after tool execution.\n"
            "- **Narrow Waist, Powerful Edge**: Leverage specialized domain skills and terminal tools efficiently without bloat.\n"
            "- **Strict Privacy & Local First**: All operations are private, confidential, and telemetry-free.\n"
        )

    def verify_tool_call(self, tool_name: str, arguments: Dict[str, Any]) -> tuple[bool, Optional[str]]:
        """Pre-execution validation hook for tool calls."""
        if not tool_name:
            return False, "Tool name cannot be empty."
        # Protect against accidental recursive self-destruction
        if tool_name == "terminal":
            cmd = arguments.get("command", "")
            if "rm -rf /" in cmd or "rm -rf ~" in cmd:
                return False, "Prohibited dangerous command sequence detected by ARC X Executive."
        return True, None

    def get_status_summary(self) -> Dict[str, Any]:
        """Return engine diagnostic status."""
        return {
            "engine": "ARC X Executive",
            "version": ARC_X_VERSION,
            "autonomous_verification": self.config.autonomous_verification,
            "caching_protection": self.config.caching_protection,
            "privacy_strict": self.config.privacy_strict,
            "objectives_tracked": len(self._active_objectives),
        }


# Singleton engine instance
_executive_instance: Optional[ArcXExecutive] = None


def get_arc_x_executive() -> ArcXExecutive:
    """Return the global or initialized ArcXExecutive instance."""
    global _executive_instance
    if _executive_instance is None:
        _executive_instance = ArcXExecutive()
    return _executive_instance
