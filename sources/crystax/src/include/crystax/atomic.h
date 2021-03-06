/*
 * Copyright (c) 2011-2015 CrystaX.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice, this list of
 *       conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright notice, this list
 *       of conditions and the following disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY CrystaX ''AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CrystaX OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those of the
 * authors and should not be interpreted as representing official policies, either expressed
 * or implied, of CrystaX.
 */

#ifndef __CRYSTAX_SRC_INCLUDE_CRYSTAX_ATOMIC_H_36D0C09D3B094FB3A2C0D3F5C923C88D
#define __CRYSTAX_SRC_INCLUDE_CRYSTAX_ATOMIC_H_36D0C09D3B094FB3A2C0D3F5C923C88D

#define __crystax_atomic_fetch(p) __sync_add_and_fetch(p, 0)

#define __crystax_atomic_swap(p, v) \
    ({ \
        __typeof__(v) prev; \
        do { \
            prev = *p; \
        } while (__sync_val_compare_and_swap(p, prev, v) != prev); \
    })

#endif /* __CRYSTAX_SRC_INCLUDE_CRYSTAX_ATOMIC_H_36D0C09D3B094FB3A2C0D3F5C923C88D */
