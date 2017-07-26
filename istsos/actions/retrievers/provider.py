# -*- coding: utf-8 -*-
# istSOS. See https://istsos.org/
# License: https://github.com/istSOS/istsos3/master/LICENSE.md
# Version: v3.0.0

import asyncio
import istsos
from istsos.actions.retrievers.retriever import Retriever
from istsos.entity.provider import Provider as EProvider


class Provider(Retriever):
    @asyncio.coroutine
    def process(self, request):
        request['provider'] = EProvider(json_source=(
                yield from istsos.get_state()
            ).get_provider()
        )
